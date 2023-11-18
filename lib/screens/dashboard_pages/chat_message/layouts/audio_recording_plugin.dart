import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:microphone/microphone.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter_sound/flutter_sound.dart';
import 'package:chatify_web/config.dart';
import 'package:just_audio/just_audio.dart';

enum AudioState { recording, stop, play, notStarted }

class AudioRecordingPlugin extends StatefulWidget {
  final String? type;
  final int? index;

  const AudioRecordingPlugin({Key? key, this.type, this.index})
      : super(key: key);

  @override
  AudioRecordingPluginState createState() => AudioRecordingPluginState();
}

class AudioRecordingPluginState extends State<AudioRecordingPlugin> {
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool isLoading = false;
  Codec codec = Codec.aacMP4;
  late String recordFilePath;
  int counter = 0;
  String statusText = "";
  bool isRecording = false;
  bool isComplete = false;
  bool mPlaybackReady = false;
  String mPath = 'tau_file.mp4';
  Timer? _timer;
  int recordingTime = 0;
  String? filePath;
  bool mPlayerIsInit = false;
  bool mRecorderIsInited = false;
  File? recordedFile;
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  bool isPlaying = false, isSupported = true,isAlertShow = false;

  MicrophoneRecorder? recorder;
  AudioState audioState = AudioState.notStarted;

  AudioPlayer player = AudioPlayer();

  Future<void> checkPermission() async {
    final permission =
        await html.window.navigator.permissions?.query({'name': 'microphone'});
    log("permission : ${permission!.state}");
    if (permission.state == 'prompt' || permission.state == "denied") {
      WidgetsFlutterBinding.ensureInitialized();
      dynamic value =
          await html.window.navigator.getUserMedia(audio: true, video: true);
      log("AUDIO : $value");
    }
  }

  // record audio
  getRecorderFn(context) {
    if (isSupported) {
      if (!mRecorderIsInited || !mPlayer!.isStopped) {
        log("audioState : $mRecorderIsInited");
        log("audioState : $mPlayer");
        return null;
      }
      if (audioState == AudioState.notStarted) {
        record();
      } else {
        stopRecorder();
      }
    }else{
      isAlertShow =true;
      setState(() {
        
      });
    }
    
  }

  // record audio
  record() async {
    log("CHECK RECRD");
    handleAudioState(audioState);
    /* Directory directory = await getApplicationDocumentsDirectory();
    String filepath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    mPath = filepath;
    mRecorder!.startRecorder(toFile: filepath, codec: codec).then((value) {
      setState(() {});
    });
    recordFilePath = await getFilePath();
    startTimer();
    setState(() {});*/
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      recordingTime++;
      setState(() {});
    });
  }

  // stop recording method
  stopRecorder() async {
    handleAudioState(audioState);
    /* await mRecorder!.stopRecorder().then((value) {
      mPlaybackReady = true;
      _timer!.cancel();
      recordedFile = File(mPath);
      setState(() {});
    });*/
  }

  @override
  void initState() {
    // TODO: implement initState
    //recorder = MicrophoneRecorder()..init();
    recorder = MicrophoneRecorder()
      ..init().onError((error, stackTrace) {
        isSupported = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          backgroundColor: appCtrl.appTheme.greenColor,
        ));
      });
    checkPermission().then((value) {
      mRecorderIsInited = true;
      setState(() {});
    });

    super.initState();
  }

  // play recorded audio
  getPlaybackFn() {
    handleAudioState(audioState);
  }

  void handleAudioState(AudioState state) {
    log("state ; $state");
    setState(() {
      if (audioState == AudioState.notStarted) {
        // Starts recording

        recorder!.start().onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.toString()),
            backgroundColor: appCtrl.appTheme.greenColor,
          ));
        }).then((value) {
          startTimer();
          audioState = AudioState.recording;
        });

        // Finished recording
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.play;
        recorder!.stop();
        _timer!.cancel();
        // Play recorded audio
      } else if (audioState == AudioState.play) {
        audioState = AudioState.stop;
        log("URL : ${recorder!.value.recording!}");
        player.setUrl(recorder!.value.recording!.url).then((_) {
          return player.play().then((value) {
            setState(() {
              audioState = AudioState.play;
            });
          }).onError((error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error.toString()),
              backgroundColor: appCtrl.appTheme.greenColor,
            ));
          });
        });
        // Stop recorded audio
      } else if (audioState == AudioState.stop) {
        audioState = AudioState.play;
        player.stop();
      }
    });
  }

  // play recorded audio
  void play() {
    assert(mPlayerIsInit &&
        mPlaybackReady &&
        mRecorder!.isStopped &&
        mPlayer!.isStopped);
    mPlayer!
        .startPlayer(
            fromURI: mPath,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  // stop player
  void stopPlayer() {
    mPlayer!.stopPlayer().then((value) {
      _timer!.cancel();
      recordedFile = File(mPath);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.i5),
                  child: Icon(Icons.cancel)))
        ]),
        const SizedBox(height: Sizes.s20),
        if(isAlertShow)
          Text("Not Support in the System",style: AppCss.poppinsblack16.textColor(appCtrl.appTheme.redColor),).marginOnly(bottom: Insets.i5),

        Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: appCtrl.appTheme.grey.withOpacity(.5),
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.r30))),
            padding: const EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //audio start and stop icon
                  VoiceStopIcons(
                      onPressed: () => getRecorderFn(context), mRecorder: mRecorder),
                  Text(recordingTime.toString(),
                      style: AppCss.poppinsMedium14
                          .textColor(appCtrl.appTheme.txt)),
                  StopArrowIcons(
                      onPressed: () => getPlaybackFn(), mPlayer: mPlayer)
                ])),
        const VSpace(Sizes.s10),
        CommonButton(
            title: fonts.done.tr,
            style:
                AppCss.poppinsMedium12.textColor(appCtrl.appTheme.whiteColor),
            onTap: () {
              stopPlayer();

              Get.back(result: recorder!.value.recording!.url);
            },
            color: appCtrl.isTheme
                ? appCtrl.appTheme.white
                : appCtrl.appTheme.primary),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.all(Insets.i10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                      height: Sizes.s20,
                      width: Sizes.s20,
                      child: CircularProgressIndicator()),
                  const HSpace(Sizes.s10),
                  Text(fonts.audioProcess.tr)
                ]),
          )
      ],
    );
  }
}
