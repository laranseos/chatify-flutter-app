import '../config.dart';

class BackIcon extends StatelessWidget {
  final bool verticalPadding;
final GestureTapCallback? onTap;
  const BackIcon({Key? key, this.verticalPadding = false,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.s40,width: Sizes.s40,
      decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 0.8),
          ),
          shadows: const [
            BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 1,
                color: Color.fromRGBO(0, 0, 0, 0.08))
          ],
          color: appCtrl.appTheme.white),
      padding: EdgeInsets.symmetric(
          horizontal: Insets.i16,
          vertical: verticalPadding ? Insets.i15 : Insets.i10),
      child: SvgPicture.asset(
        appCtrl.isRTL ? svgAssets.arrowForward : svgAssets.arrowBack,
        height: Sizes.s18,
        colorFilter: ColorFilter.mode(appCtrl.isTheme?appCtrl.appTheme.chatBgColor : appCtrl.appTheme.blackColor, BlendMode.srcIn),
      ),
    ).inkWell(onTap: onTap);
  }
}
