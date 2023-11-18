
import 'package:chatify_web/widgets/common_video_view.dart';
import 'package:video_player/video_player.dart';

import '../../../../../config.dart';

class ChatVideo extends StatefulWidget {
  final dynamic snapshot;

  const ChatVideo({Key? key, this.snapshot}) : super(key: key);

  @override
  State<ChatVideo> createState() => _ChatVideoState();
}

class _ChatVideoState extends State<ChatVideo> {
  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState

    videoController = VideoPlayerController.network(widget.snapshot);
    initializeVideoPlayerFuture = videoController!.initialize();
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
            child: AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,

                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(videoController!))
                .height(Sizes.s74)
                .width(Sizes.s74))
        .inkWell(
            onTap: () => Get.to(CommonVideoView(snapshot: widget.snapshot)));
  }
}
