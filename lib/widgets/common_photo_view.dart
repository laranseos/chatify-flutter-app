import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:chatify_web/config.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class CommonPhotoView extends StatefulWidget {
  final String? image;

  const CommonPhotoView({Key? key, this.image}) : super(key: key);

  @override
  State<CommonPhotoView> createState() => _CommonPhotoViewState();
}

class _CommonPhotoViewState extends State<CommonPhotoView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appCtrl.appTheme.blackColor,
      appBar: AppBar(
        backgroundColor: appCtrl.appTheme.blackColor,
        actions: [
          Icon(Icons.download_outlined, color: appCtrl.appTheme.whiteColor)
              .marginSymmetric(horizontal: Insets.i20)
              .inkWell(onTap: () async {
                log("IMAGE URL :${widget.image}");
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
              var response = await Dio()
                  .get(widget.image!,
                  options: Options(responseType: ResponseType.bytes));
              final result = await ImageGallerySaver.saveImage(
                  Uint8List.fromList(response.data),
                  quality: 60,
                  name: "probot");
              isLoading = false;
              log("RESULT : $result");
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
      body:  Stack(
        children: [
          PhotoView(imageProvider: NetworkImage(widget.image!)),
          if(isLoading)
            CommonLoader(isLoading: isLoading)
        ],
      ),
    );
  }
}
