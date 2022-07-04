import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:image_picker/image_picker.dart';
import '/bloc/activity/activity-cubit.dart';
import '/bloc/auth/auth-cubit.dart';
import '/const.dart';
import '/view/utils/bottom_bar.dart';

class UpdateProfileImage extends StatelessWidget {
  final XFile file;
  final String profileURL;
  UpdateProfileImage(
    this.file, {
    this.profileURL,
  }){
    log(file.toString());
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Container(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (file != null)
              CustomRaisedButton(
                onPressed: () async {
                  await BlocProvider.of<ActivityCubit>(context, listen: false)
                      .updateProfile(PlatformFile(name: file.name, size: await file.length(),readStream: file.openRead()));
                  BlocProvider.of<AuthCubit>(context, listen: false)
                      .checkAuthStatus();
                  Navigator.of(context).pop();

                },
                title: 'Upload',
              )
          ],
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
        title: Text(
          file == null ? 'Student Profile' : 'Update Profile',
          style: buildTextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child:FutureBuilder<Uint8List>(
          future: file.readAsBytes(),
          builder: (context,snapshot) {
            if(snapshot.hasData) {
            return Container(child: Image.memory(snapshot.data));
          } else{
            return loadingBar;
            }
          }
        ),
           // file == null ? CachedImage(imageUrl: profileURL) : Image.file(file),
      ),
    );
  }
}
