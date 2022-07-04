import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_viewer.dart';


class AudioRecordPage extends StatefulWidget {
  const AudioRecordPage({Key key}) : super(key: key);

  @override
  State<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
   final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  List<double> decibels = [];
  StreamSubscription _mRecordingDataSubscription;
  String fileName;
  String filePath;
  bool isRecorded = true;
  bool isRecordedCompleted = false;

  @override
  void initState() {
    super.initState();
    fileName = 'audio_${DateTime.now().microsecondsSinceEpoch}.aac';
    getPermission();
    setPlayer();
  }

  Future<void> setPlayer() async {
    var tempDir = await getTemporaryDirectory();
    filePath = '${tempDir.path}/$fileName';
  }

  @override
  void dispose() {
    _soundRecorder.closeRecorder();
    super.dispose();
  }

  Future<bool> getPermission() async {
    var requestPermission = await Permission.microphone.status;
    if (!requestPermission.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title:  Text('Audio Recorder',style: buildTextStyle(),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: StreamBuilder<RecordingDisposition>(
                  stream: _soundRecorder.onProgress,
                  builder: (context, snapshot) {
                    var duration = snapshot.hasData
                        ? snapshot.data.duration
                        : Duration.zero;
                    return Text(
                      duration.toHoursMinutesSeconds(),
                      style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            StreamBuilder<RecordingDisposition>(
              stream: _soundRecorder.onProgress,
              builder: (context, snapshot) {
                var heightFactor =
                    (snapshot.hasData ? snapshot.data.decibels : 0.0) / 150;
                decibels.add(heightFactor < 1 ? heightFactor : 1);
                return AudioWave(
                  bars: decibels,
                  width: MediaQuery.of(context).size.width,
                  isScrollEnable: !_soundRecorder.isRecording,
                );
              },
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: Colors.deepOrange,
                              width: 30.0,
                            ),
                          ),
                          primary: Colors.white,
                          padding: const EdgeInsets.all(42.0),
                        ),
                        onPressed: isRecorded
                            ? () async {
                          if (await getPermission()) {
                            setState(() {
                              isRecordedCompleted = false;
                              isRecorded = false;
                              decibels.clear();
                            });
                            await _soundRecorder.openRecorder();
                            await _soundRecorder.setSubscriptionDuration(
                                const Duration(milliseconds: 60));
                            await _soundRecorder.startRecorder(
                              codec: Codec.aacADTS,
                              toFile: filePath,
                            );
                            setState(() {});
                          }
                        }
                            : _soundRecorder.isRecording
                            ? () async {
                          await _soundRecorder.pauseRecorder();
                          setState(() {});
                        }
                            : () async {
                          await _soundRecorder.resumeRecorder();
                          setState(() {});
                        },
                        child: Icon(
                          isRecorded
                              ? Icons.mic
                              : _soundRecorder.isRecording
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 35.0,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    if (!isRecorded)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: Colors.deepOrange,
                                  width: 1.0,
                                ),
                              ),
                              primary: Colors.white,
                              padding: const EdgeInsets.all(10.0),
                            ),
                            onPressed: () async {
                              await _soundRecorder.stopRecorder();
                              if (_mRecordingDataSubscription != null) {
                                await _mRecordingDataSubscription?.cancel();
                                _mRecordingDataSubscription = null;
                              }
                              setState(() {
                                isRecordedCompleted = true;
                                isRecorded = true;
                              });
                            },
                            child: const Icon(
                              Icons.stop,
                              size: 35.0,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: isRecordedCompleted
                      ? InkResponse(
                    onTap: () {
                      var file = File(filePath);
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        builder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 5.0,
                                width: 100.0,
                                decoration: const ShapeDecoration(
                                  color: Colors.grey,
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            FileViewer(
                              type: 'aac',
                              resourceType: MediaResourceType.file,
                              file: PlatformFile(
                                name: fileName,
                                path: file.path,
                                size: file.lengthSync(),
                              ),
                              isExpanded: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  primary: const Color(0xff6fcf97),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop(PlatformFile(
                                    name: fileName,
                                    path: file.path,
                                    size: file.lengthSync(),
                                  ));
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                                label: const Text('Done'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.deepOrange, width: 2.0),
                      ),
                      child: const Icon(Icons.fast_forward),
                    ),
                  )
                      : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioWave extends StatefulWidget {
  const AudioWave({
    @required this.bars,
    this.height = 150,
    this.width = 200,
    this.isScrollEnable = false,
    Key key,
  }) : super(key: key);
  final List<double> bars;
  final bool isScrollEnable;

  /// [height] is the height of the widget.
  ///
  final double height;

  /// [width] is the width of the widget. Input the
  final double width;

  @override
  _AudioWaveState createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  bool isScrollEnable = false;
  List<double> bars = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bars = widget.bars;
    isScrollEnable = widget.isScrollEnable;
  }

  @override
  void didUpdateWidget(AudioWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    bars = widget.bars;
    isScrollEnable = widget.isScrollEnable;
    setState(() {});
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: isScrollEnable
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var bar in bars)
              SizedBox(
                width: 9.5,
                child: Center(
                  child: Container(
                    height: bar * widget.height,
                    width: 1.5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(0.75),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
