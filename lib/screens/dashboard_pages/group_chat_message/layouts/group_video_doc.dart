import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../../../config.dart';

class GroupVideoDoc extends StatefulWidget {
  final DocumentSnapshot? document;
final VoidCallback? onLongPress,onTap;
final bool isReceiver;
final String? currentUserId;
  const GroupVideoDoc({Key? key, this.document,this.onLongPress,this.isReceiver = false, this.currentUserId,this.onTap}) : super(key: key);

  @override
  State<GroupVideoDoc> createState() => GroupVideoDocState();
}

class GroupVideoDocState extends State<GroupVideoDoc> {
  VideoPlayerController? videoController;
   Future<void>? initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    log(widget.document!["content"]);
    log(widget.document!["content"]);
    if (widget.document!["type"] == MessageType.video.name) {
      videoController = VideoPlayerController.network(
        widget.document!["content"].contains("-BREAK-") ? widget.document!["content"].split("-BREAK-")[1] :widget.document!["content"],
      );
      initializeVideoPlayerFuture = videoController!.initialize();
    }
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return InkWell(
              onLongPress: widget.onLongPress,
              onTap: widget.onTap,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (widget.isReceiver)
                            if (widget.document!["sender"] != widget.currentUserId)
                              Column(children: [
                                Text(widget.document!['senderName'],
                                    style: AppCss.poppinsMedium12
                                        .textColor(appCtrl.appTheme.primary)).paddingAll(Insets.i5).decorated(color: appCtrl.appTheme.whiteColor,borderRadius: BorderRadius.circular(AppRadius.r20)),

                              ]),
                          AspectRatio(
                            aspectRatio: videoController!.value.aspectRatio,
                            // Use the VideoPlayer widget to display the video.
                            child: VideoPlayer(videoController!)
                          ).height(Sizes.s250),
                          const VSpace(Sizes.s5),
                          IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.document!.data().toString().contains('isFavourite'))
                                    Icon(Icons.star,color: appCtrl.appTheme.txtColor,size: Sizes.s10),
                                  const HSpace(Sizes.s3),
                                  Text(
                                    DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(widget.document!['timestamp']))),
                                    style:
                                    AppCss.poppinsMedium12.textColor(appCtrl.appTheme.txtColor),
                                  )
                                ]
                              )
                          )
                        ],
                      ),
                      if (widget.document!.data().toString().contains('emoji'))
                        EmojiLayout(emoji: widget.document!["emoji"])
                    ],
                  ),

                ]
              ).marginSymmetric(vertical: Insets.i5,horizontal: Insets.i10).inkWell(onTap: widget.onTap),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return  Container();
          }
        },
      );
    });
  }
}
