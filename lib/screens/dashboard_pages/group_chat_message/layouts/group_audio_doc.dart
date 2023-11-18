import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';

import '../../../../config.dart';

class GroupAudioDoc extends StatefulWidget {
  final VoidCallback? onLongPress, onTap;
  final DocumentSnapshot? document;

  final bool isReceiver;
  final String? currentUserId;

  const GroupAudioDoc(
      {Key? key,
      this.onLongPress,
      this.document,
      this.isReceiver = false,
      this.currentUserId,
      this.onTap})
      : super(key: key);

  @override
  State<GroupAudioDoc> createState() => _GroupAudioDocState();
}

class _GroupAudioDocState extends State<GroupAudioDoc>
    with WidgetsBindingObserver {
  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration positions = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();
  int value = 2;

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

  Future<void> checkPermission() async {
    final permission =
        await html.window.navigator.permissions?.query({'name': 'microphone'});
    log("permission : ${permission!.state}");
    if (permission.state == 'prompt' || permission.state == "denied") {
      WidgetsFlutterBinding.ensureInitialized();
      await html.window.navigator.getUserMedia(audio: true, video: true);
    }
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
              inactiveColor: widget.isReceiver ? appCtrl.appTheme.blackColor: appCtrl.appTheme.whiteColor,
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
      audioDuration = event.duration!.inSeconds;
      setState(() {

      });
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
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return InkWell(
        onLongPress: widget.onLongPress,
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: Insets.i10, horizontal: Insets.i10),
                    padding: const EdgeInsets.symmetric(
                        vertical: Insets.i5, horizontal: Insets.i15),
                    decoration: BoxDecoration(
                      color: widget.isReceiver
                          ? appCtrl.appTheme.chatSecondaryColor
                          : appCtrl.appTheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.r15),
                    ),
                    height: widget.isReceiver ? Sizes.s100 : Sizes.s90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.isReceiver)
                          if (widget.document!["sender"] !=
                              widget.currentUserId)
                            Align(
                                alignment: Alignment.topLeft,
                                child: Column(children: [
                                  Text(widget.document!['senderName'],
                                      style: AppCss.poppinsMedium12
                                          .textColor(appCtrl.appTheme.primary)),
                                  const VSpace(Sizes.s8)
                                ])),
                        Expanded(
                            child: Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (!widget.isReceiver)
                              Row(
                                children: [
                                  decryptMessage(widget.document!['content'])
                                          .contains("-BREAK-")
                                      ? SvgPicture.asset(svgAssets.headPhone)
                                          .paddingAll(Insets.i10)
                                          .decorated(
                                              color:
                                                  appCtrl.appTheme.darkRedColor,
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
                            IntrinsicHeight(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  InkWell(
                                      onTap: () async {
                                        log("isPlaying : $isPlaying");
                                        if (isPlaying) {
                                          pause();
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
                                  decryptMessage(widget.document!['content'])
                                          .contains("-BREAK-")
                                      ? SvgPicture.asset(svgAssets.headPhone,height: Sizes.s30,)
                                          .paddingAll(Insets.i10)
                                          .decorated(
                                              color:
                                                  appCtrl.appTheme.darkRedColor,
                                              shape: BoxShape.circle)
                                      : Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Image.asset(imageAssets.user,height: Sizes.s30)
                                                .paddingAll(Insets.i10)
                                                .decorated(
                                                    color: appCtrl
                                                        .appTheme.primary
                                                        .withOpacity(.5),
                                                    shape: BoxShape.circle),
                                            SvgPicture.asset(svgAssets.speaker1)
                                          ],
                                        ),
                                ],
                              ),
                          ],
                        )),
                        IntrinsicHeight(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.document!
                                .data()
                                .toString()
                                .contains('isFavourite'))
                              Icon(Icons.star,
                                  color: appCtrl.appTheme.txtColor,
                                  size: Sizes.s10),
                            const HSpace(Sizes.s3),
                            Text(
                              DateFormat('HH:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                      widget.document!['timestamp']))),
                              style: AppCss.poppinsMedium12
                                  .textColor(appCtrl.appTheme.txtColor),
                            ),
                          ],
                        ))
                      ],
                    )),
                if (widget.document!.data().toString().contains('emoji'))
                  EmojiLayout(emoji: widget.document!["emoji"])
              ],
            ),
          ],
        ),
      );
    });
  }
}
