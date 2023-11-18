import '../../../../../config.dart';

class ShareButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  const ShareButton({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(Insets.i11),
      margin:const EdgeInsets.symmetric( horizontal: Insets.i20, vertical: Insets.i20),
      decoration:  ShapeDecoration(
        color: appCtrl.appTheme.whiteColor,
        shape:   SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 8,cornerSmoothing: 1)),
      ),
      child: SvgPicture.asset(
        svgAssets.share,
        colorFilter:ColorFilter.mode(appCtrl.appTheme.blackColor, BlendMode.srcIn) ,
        height: Sizes.s18,
      )

    )
        .inkWell(onTap:onTap);
  }
}
