import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:chatify_web/config.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';


class CommonVideoView extends StatefulWidget {
  final dynamic snapshot;

  const CommonVideoView({Key? key, this.snapshot}) : super(key: key);

  @override
  State<CommonVideoView> createState() => _CommonVideoViewState();
}

class _CommonVideoViewState extends State<CommonVideoView> {
  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool startedPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    videoController = VideoPlayerController.network(
        widget.snapshot
    ) ..addListener(() {
      log("isPlaying : ${videoController!.value.isPlaying}");
      log("isBuffering : ${videoController!.value.isBuffering}");
      setState(() {});
    });
    initializeVideoPlayerFuture = videoController!.initialize();
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: appCtrl.appTheme.transparentColor,
      appBar: AppBar(
        backgroundColor: appCtrl.appTheme.transparentColor,
        actions: [
          Icon(Icons.download_outlined, color: appCtrl.appTheme.whiteColor)
              .marginSymmetric(horizontal: Insets.i20)
              .inkWell(onTap: () async {
            log("IMAGE URL :${widget.snapshot}");
            final androidInfo = await DeviceInfoPlugin().androidInfo;
            late final Map<Permission, PermissionStatus> status;

            if (Platform.isAndroid) {
              if (androidInfo.version.sdkInt <= 32) {
                status = await [Permission.storage].request();
              } else {
                status = await [Permission.photos].request();
              }
            } else {
              status = await [Permission.photosAddOnly].request();
            }

            var allAccept = true;
            status.forEach((permission, status) {
              if (status != PermissionStatus.granted) {
                allAccept = false;
              }
            });

            if (allAccept) {
              isLoading = true;
              setState(() {

              });
              var appDocDir = await getTemporaryDirectory();
              String savePath = "${appDocDir.path}/temp.mp4";
              await Dio().download(widget.snapshot, savePath);
              final result = await ImageGallerySaver.saveFile(savePath);
              isLoading = false;
              log("result : $result");
              setState(() {

              });
              Get.snackbar('Success', "Image Downloaded Successfully",
                  backgroundColor: appCtrl.appTheme.greenColor,
                  colorText: appCtrl.appTheme.white);

              setState(() {

              });
            } else {
              isLoading = false;
              Get.snackbar('Alert!', "Something Went Wrong",
                  backgroundColor: appCtrl.appTheme.error,
                  colorText: appCtrl.appTheme.white);
              setState(() {

              });
            }
          })
        ],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: videoController!.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.

              child: VideoPlayer(videoController!,),
            ),
            IconButton(

                icon: Icon(
                    videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: appCtrl.appTheme.whiteColor)
                    .marginAll(Insets.i3)
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
      ),
    );
  }
}
