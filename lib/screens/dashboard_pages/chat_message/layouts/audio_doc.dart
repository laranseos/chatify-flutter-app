import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:universal_html/html.dart' as html;
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';

class AudioDoc extends StatefulWidget {
  final VoidCallback? onLongPress,onTap;
  final dynamic document;
  final bool isReceiver,isBroadcast;

  const AudioDoc(
      {Key? key, this.onLongPress, this.document, this.isReceiver = false, this.isBroadcast = false,this.onTap})
      : super(key: key);

  @override
  State<AudioDoc> createState() => _AudioDocState();
}

class _AudioDocState extends State<AudioDoc> with WidgetsBindingObserver {
  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration positions = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();
  int value = 2;

  Future<void> checkPermission() async {
    final permission =
    await html.window.navigator.permissions?.query({'name': 'microphone'});
    log("permission : ${permission!.state}");
    if (permission.state == 'prompt' || permission.state == "denied") {
      WidgetsFlutterBinding.ensureInitialized();
      await html.window.navigator.getUserMedia(audio: true, video: true);
    }

  }

  void play() async {
    log("play");

    log("time : ${value.minutes}");
    audioPlayer.play().then((value) {
      setState(() {
        isPlaying = true;
      });
    });
    isPlaying = true;
    setState(() {

    });
  }

  void pause() {
    isPlaying = false;
    setState(() {

    });
    log("SATTE : ${audioPlayer.processingState}");
    audioPlayer.pause();
    setState(() {

    });
  }

  void seek(Duration position) {
    log("pso :$position");
    audioPlayer.seek(position);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  /// Optional
  Widget slider() {
    return StreamBuilder<Duration?>(
        stream: audioPlayer.positionStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            timeProgress =snapshot.data!.inSeconds;

          }
          return SliderTheme(
            data: SliderThemeData(overlayShape: SliderComponentShape.noThumb),
            child: Slider(
                value: snapshot.hasData ?  snapshot.data!.inSeconds.toDouble() : timeProgress.toDouble(),
                max: audioDuration.toDouble(),
                activeColor: appCtrl.appTheme.orangeColor,
                inactiveColor:widget.isReceiver ?appCtrl.appTheme.blackColor : appCtrl.appTheme.whiteColor,
                onChanged: (value) async {
                  seekToSec(value.toInt());
                }),
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();

    /// Compulsory
    audioPlayer.playbackEventStream.listen((event) {
      log("EVE : $event");
      timeProgress = audioPlayer.position.inSeconds;
      audioDuration = event.duration == null ? 0 : event.duration!.inSeconds;

    }, onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
    String url = decryptMessage(widget.document!['content']).contains("-BREAK")
        ? decryptMessage(widget.document!['content']).split("-BREAK-")[1]
        : decryptMessage(widget.document!['content']);
    log("url : ${decryptMessage(widget.document!['content'])}");
    audioPlayer.setUrl(url);

    log("audioPlayer ; ${audioPlayer.duration}");
    timeProgress = audioPlayer.position.inSeconds;
  }


  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: widget.onLongPress,
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SmoothContainer(
                    color: widget.isReceiver
                        ? appCtrl.appTheme.chatSecondaryColor
                        : appCtrl.appTheme.primary,
                    smoothness: 0.9,
                    height: Sizes.s80,
                    borderRadius: BorderRadius.circular(AppRadius.r15),
                    margin: const EdgeInsets.symmetric(vertical: Insets.i5),
                    padding: const EdgeInsets.symmetric(
                        vertical: Insets.i10, horizontal: Insets.i15),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (!widget.isReceiver)
                          Row(
                            children: [
                              decryptMessage(widget.document!["content"]).contains("-BREAK-")
                                  ? SvgPicture.asset(svgAssets.headPhone)
                                  .paddingAll(Insets.i10)
                                  .decorated(
                                  color: appCtrl.appTheme.darkRedColor,
                                  shape: BoxShape.circle)
                                  : Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Image.asset(imageAssets.user1),
                                  SvgPicture.asset(svgAssets.speaker)
                                ],
                              ),
                              const HSpace(Sizes.s10),
                            ],
                          ),
                        //Spacer(),
                        IntrinsicHeight(
                            child: Row(mainAxisSize: MainAxisSize.min,children: [
                              InkWell(
                                  onTap: () async {
                                    if (isPlaying) {
                                      await audioPlayer.pause();
                                    } else {
                                      play();
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    isPlaying
                                        ? svgAssets.pause
                                        : svgAssets.arrow,
                                    height: Sizes.s15,
                                    colorFilter: ColorFilter.mode(widget.isReceiver
                                        ? appCtrl.appTheme.primary
                                        : appCtrl.appTheme.blackColor, BlendMode.srcIn),
                                  )),
                              const HSpace(Sizes.s10),
                              Column(
                                children: [
                                  slider(),
                                  const VSpace(Sizes.s5),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      StreamBuilder<Duration?>(
                                          stream: audioPlayer.positionStream,
                                          builder: (context, snapshot){
                                            if(snapshot.hasData){
                                              timeProgress =snapshot.data!.inSeconds;

                                            }
                                            return Text(getTimeString(timeProgress),
                                                style: AppCss.poppinsMedium12
                                                    .textColor(appCtrl
                                                    .appTheme.blackColor));
                                          }
                                      ),
                                      const HSpace(Sizes.s80),
                                      Text(getTimeString(audioDuration),
                                          style: AppCss.poppinsMedium12
                                              .textColor(appCtrl
                                              .appTheme.blackColor))
                                    ],
                                  )
                                ],
                              ).marginOnly(top: Insets.i16)
                            ])),
                        if (widget.isReceiver)
                          Row(
                            children: [
                              const HSpace(Sizes.s10),
                              decryptMessage(widget.document!["content"]).contains("-BREAK-")
                                  ? SvgPicture.asset(svgAssets.headPhone,height: Sizes.s30,)
                                  .paddingAll(Insets.i10)
                                  .decorated(
                                  color: appCtrl.appTheme.darkRedColor,
                                  shape: BoxShape.circle)
                                  : Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Image.asset(imageAssets.user,height: Sizes.s30)
                                      .paddingAll(Insets.i10)
                                      .decorated(
                                      color: appCtrl.appTheme.primary
                                          .withOpacity(.5),
                                      shape: BoxShape.circle),
                                  SvgPicture.asset(svgAssets.speaker1)
                                ],
                              ),
                            ],
                          ),
                      ],
                    )
                ),
                if (widget.document!.data().toString().contains('emoji'))
                  EmojiLayout(emoji: widget.document!["emoji"]),
              ],
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!widget.isReceiver && !widget.isBroadcast)
                    Icon(Icons.done_all_outlined,
                        size: Sizes.s15,
                        color: widget.document!['isSeen'] == true
                            ? appCtrl.appTheme.primary
                            : appCtrl.appTheme.gray),
                  const HSpace(Sizes.s5),
                  Text(
                    DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(widget.document!['timestamp']))),
                    style:
                    AppCss.poppinsMedium12.textColor(appCtrl.appTheme.txtColor),
                  )
                ],
              ).marginSymmetric(vertical: Insets.i3),
            )
          ],
        ).marginSymmetric(horizontal: Insets.i10)
    );
  }
}