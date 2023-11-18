

import '../../../../config.dart';

class ImagePickerLayout extends StatelessWidget {
  final GestureTapCallback? cameraTap,galleryTap;
  const ImagePickerLayout({Key? key,this.cameraTap,this.galleryTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: Sizes.s150,
      color: appCtrl.appTheme.whiteColor,
      alignment: Alignment.bottomCenter,
      child: Column(children: [
        const VSpace(Sizes.s20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconCreation(
                icons: Icons.camera,
                color: appCtrl.isTheme ?appCtrl.appTheme.white :  appCtrl.appTheme.primary,
                text: fonts.camera.tr,
                onTap: cameraTap),
            IconCreation(
                icons: Icons.image,
                color:appCtrl.isTheme ?appCtrl.appTheme.white :  appCtrl.appTheme.primary,
                text: fonts.gallery.tr,
                onTap:galleryTap),

          ],
        ),
      ]),
    );
  }
}
