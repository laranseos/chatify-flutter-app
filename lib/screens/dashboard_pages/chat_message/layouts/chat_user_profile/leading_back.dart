import '../../../../../config.dart';

class LeadingBack extends StatelessWidget {
  const LeadingBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(Insets.i12),
      margin:const EdgeInsets.symmetric( horizontal: Insets.i20, vertical: Insets.i20),
      decoration:  ShapeDecoration(
        color: appCtrl.appTheme.whiteColor,
        shape:   SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 8,cornerSmoothing: 1)),
      ),
      child: SvgPicture.asset(
        appCtrl.isRTL
            ? svgAssets.arrowForward
            : svgAssets.arrowBack,
        colorFilter:ColorFilter.mode(appCtrl.appTheme.blackColor, BlendMode.srcIn) ,
        height: Sizes.s18,
      )

    ).inkWell(onTap: () => Get.back());
  }
}
