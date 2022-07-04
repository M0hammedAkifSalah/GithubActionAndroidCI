import 'dart:async';
import 'dart:developer';
// import 'dart:developer';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '/export.dart';
import '/providers.dart';
import '/view/startup/welcome-add-account-page.dart';
import 'app-config.dart';
import 'model/server_mode.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}



ServerMode serverMode = ServerMode.preProduction;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if(!kIsWeb) {
    await Firebase.initializeApp();
  }

  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => EventFilter()),
          ChangeNotifierProvider(create: (_) => AssignmentFilter()),
          ChangeNotifierProvider(create: (_) => TasksFilter()),
          ChangeNotifierProvider(create: (_) => Doubts()),
          ChangeNotifierProvider(create: (_) => TimePicker()),
        ],
        child: MultiBlocProvider(
          providers: blocProvider,
          child: MyApp(),
        ),
      ),
    );
  }, (error, stackTrace) {
    if(!kIsWeb)
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    else
      log(error.toString());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppUpdateInfo _updateInfo;
  Map<String, String> appSettings ;
  bool _flexibleUpdateAvailable = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var analytics;
  Future<void> _initializeFlutterFire() async {
    if(!kIsWeb) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {}
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }
  Future<void> fetchRemoteConfig()async{
    if(!kIsWeb)
    {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      // RemoteConfigSettings(
      //   // fetchTimeoutMillis: 30 * 60 * 1000,
      //   // minimumFetchIntervalMillis: 10000,
      //   fetchTimeout: Duration(minutes: 30),
      //   minimumFetchInterval: Duration(seconds: 10),
      // );
      remoteConfig.fetch();
      remoteConfig.fetchAndActivate();
    }

    switch (serverMode) {
      case ServerMode.production:
        appSettings = {
          "version": "Prod",
          "baseURL": "https://api.grown-on-prod.gloryautotech.com/api/v1",
          "fileURL": 'https://growon-backup.s3.ap-south-1.amazonaws.com',
          "videoURL": 'https://dv9s8hvt3j51d.cloudfront.net',
        };
        break;
      case ServerMode.preProduction:
        appSettings = {
          "version": "PreProd",
          "baseURL": "https://api-preprod.growon.app/api/v1",
          "fileURL": 'https://gravity-dev1.s3.ap-south-1.amazonaws.com',
          "videoURL": 'https://d2dgphk2gfe67a.cloudfront.net'
        };
        break;
      case ServerMode.development:
        appSettings = {
          "version": "Dev",
          "baseURL": "https://api-staging.growon.app/api/v1",
          "fileURL": 'https://gravity-dev1.s3.ap-south-1.amazonaws.com',
          "videoURL": 'https://d2dgphk2gfe67a.cloudfront.net'
        };
        break;
    }
    GlobalConfiguration().loadFromMap(appSettings);
    BlocProvider.of<AuthCubit>(context).checkAuthStatus();

  }


  @override
  void initState() {
    super.initState();
    _initializeFlutterFire();
    fetchRemoteConfig();
    checkForUpdate();

    // _checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    if(!kIsWeb)
      analytics = FirebaseAnalytics.instance;
    bool firstReturn = true;
    return MaterialApp(
      navigatorObservers: [
        if(!kIsWeb)
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffFFC30A),
        inputDecorationTheme: InputDecorationTheme(),
        appBarTheme: AppBarTheme(
          color: Color(0xfff4f8fe),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        scaffoldBackgroundColor: Color(0xffF4F8FE),
        backgroundColor: Color(0xffF4F8FE),
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xffFFC30A)),
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: Color(0xffFFC30A)),
      ),
      home: BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
        // return TestResultPage();
        if (state is AccountsNotLoaded) {
          firstReturn = false;
          return WelcomeAddAccountPage();
        } else if (state is AccountsLoaded && firstReturn) {
          return KeyboardVisibilityProvider(
            child: TeacherHomePage(),
          );
        } else
          return Scaffold(
            key: _scaffoldKey,
            body: Center(
              child: loadingBar,
            ),
          );
      }),
    );
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.snapchat.android",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: "UPDATE!!!",
      dismissButtonText: "Skip",
      dialogText: "Please update the app from " + "${status.localVersion}" + " to " + "${status.storeVersion}",
      dismissAction: () {
        SystemNavigator.pop();
      },
      updateButtonText: "Lets update",
    );

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      // log(_updateInfo.immediateUpdateAllowed.toString());
    }).catchError((e) {
      log(e.toString());
    });
  }


// class ScrollBehaviour extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//       BuildContext context, Widget child, AxisDirection axisDirection) {
//     return child;
//   }
// }
}
