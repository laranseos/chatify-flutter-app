
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../../../config.dart';

class VideoDoc extends StatefulWidget {
  final dynamic document;
final  bool isBroadcast,isReceiver;
  final GestureTapCallback? onTap;
  final VoidCallback? onLongPress;
  const VideoDoc({Key? key, this.document,this.isBroadcast = false,this.isReceiver = false,this.onTap,this.onLongPress}) : super(key: key);

  @override
  State<VideoDoc> createState() => _VideoDocState();
}

class _VideoDocState extends State<VideoDoc> {
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.document!["type"] == MessageType.video.name) {
      videoController = VideoPlayerController.network(

          decryptMessage(widget.document!["content"]).contains("-BREAK-") ? decryptMessage(widget.document!["content"]).split("-BREAK-")[1] :decryptMessage(widget.document!["content"]),
      );
      initializeVideoPlayerFuture = videoController!.initialize();
    }
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return InkWell(
            onLongPress: widget.onLongPress,
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(

                          aspectRatio: videoController!.value.aspectRatio,

                          // Use the VideoPlayer widget to display the video.
                          child: VideoPlayer(videoController!),
                        ).height(Sizes.s250).clipRRect(all: AppRadius.r8).paddingAll(Insets.i5).decorated(
                            color: appCtrl.appTheme.primary,borderRadius: BorderRadius.circular(AppRadius.r8)
                        ),
                        IconButton(
                            icon: Icon(
                                videoController!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: appCtrl.appTheme.whiteColor)

                                .decorated(
                                color: appCtrl.appTheme.secondary,
                                shape: BoxShape.circle),
                            onPressed: () {
                              if (videoController!.value.isPlaying) {
                                videoController!.pause();
                              } else {
                                // If the video is paused, play it.
                                videoController!.play();
                              }
                              setState(() {});
                            }),

                      ],
                    ),
                    if (widget.document!.data().toString().contains('emoji'))
                      EmojiLayout(emoji: widget.document!["emoji"]),
                  ],
                ),

                const VSpace(Sizes.s2),
                IntrinsicHeight(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      if (widget.document!.data().toString().contains('isFavourite'))
                        Icon(Icons.star,
                            color: appCtrl.appTheme.txtColor, size: Sizes.s10),
                      const HSpace(Sizes.s3),
                      if (!widget.isBroadcast && !widget.isReceiver)
                        Icon(Icons.done_all_outlined,
                            size: Sizes.s15,
                            color: widget.document!['isSeen'] == false
                                ? appCtrl.appTheme.primary
                                : appCtrl.appTheme.gray),
                      const HSpace(Sizes.s5),
                      Text(
                          DateFormat('HH:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(widget.document!['timestamp']))),
                          style:
                          AppCss.poppinsMedium12.textColor(appCtrl.appTheme.txtColor))
                    ]))
              ],
            ).paddingSymmetric(horizontal: Insets.i8,vertical: Insets.i8).inkWell(onTap: widget.onTap),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Container();
        }
      },
    );
  }
}
