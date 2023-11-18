import 'package:dotted_border/dotted_border.dart';
import 'package:video_player/video_player.dart';
import '../../../../config.dart';
import 'dart:math';

double radius = 27.0;

double colorWidth(double radius, int statusCount, double separation) {
  return ((2 * pi * radius) - (statusCount * separation)) / statusCount;
}

double separation(int statusCount) {
  if (statusCount <= 20) {
    return 3.0;
  } else if (statusCount <= 30) {
    return 1.8;
  } else if (statusCount <= 60) {
    return 1.0;
  } else {
    return 0.3;
  }
}

class StatusLayout extends StatefulWidget {
  final Status? snapshot;
  final GestureTapCallback? onTap;

  const StatusLayout({Key? key, this.snapshot, this.onTap}) : super(key: key);

  @override
  State<StatusLayout> createState() => _StatusLayoutState();
}

class _StatusLayoutState extends State<StatusLayout> {
  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1]
            .statusType ==
        StatusType.video.name) {
      videoController = VideoPlayerController.network(
        widget
            .snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].image!,
      );
      initializeVideoPlayerFuture = videoController!.initialize();
    }
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DottedBorder(
        color:  appCtrl.appTheme.primary,
        padding: const EdgeInsets.all(Insets.i2),
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.round,
        radius: const SmoothRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
        dashPattern:widget.snapshot!.photoUrl!.length == 1
            ? [
          //one status
          (2 * pi * (radius + 2)),
          0,
        ]
            : [
          //multiple status
          colorWidth(radius + 2,widget.snapshot!.photoUrl!.length,
              separation(widget.snapshot!.photoUrl!.length)),
          separation(widget.snapshot!.photoUrl!.length),
        ],
        strokeWidth: 1,
        child: Stack(alignment: Alignment.bottomRight, children: [
          widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1]
                      .statusType ==
                  StatusType.text.name
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.i4),
                  height: Sizes.s50,
                  width: Sizes.s50,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      color: Color(int.parse(
                          widget
                              .snapshot!
                              .photoUrl![
                                  widget.snapshot!.photoUrl!.length - 1]
                              .statusBgColor!,
                          radix: 16)),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 12, cornerSmoothing: 0.8),
                      )),
                  child: Text(
                    widget
                        .snapshot!
                        .photoUrl![widget.snapshot!.photoUrl!.length - 1]
                        .statusText!,
                    textAlign: TextAlign.center,
                    style: AppCss.poppinsMedium10
                        .textColor(appCtrl.appTheme.whiteColor),
                  ))
              : widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1]
                          .statusType ==
                      StatusType.image.name
                  ? CommonImage(
                      height: Sizes.s50,
                      width: Sizes.s50,
                      image: widget
                          .snapshot!
                          .photoUrl![widget.snapshot!.photoUrl!.length - 1]
                          .image!
                          .toString(),
                      name: widget.snapshot!.username)
                  : ClipRRect(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 12, cornerSmoothing: 1),
                      child: AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(videoController!),
                      ).height(Sizes.s50).width(Sizes.s50))
        ]),
      ),
      const VSpace(Sizes.s5),
      Text(widget.snapshot!.username!,
          overflow: TextOverflow.ellipsis,
          style: AppCss.poppinsMedium12.textColor(appCtrl.appTheme.blackColor)).width(Sizes.s50)
    ]).inkWell(onTap: widget.onTap);
  }
}
