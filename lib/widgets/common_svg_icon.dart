import '../config.dart';

class CommonSvgIcon extends StatelessWidget {
  final String? icon;
  const CommonSvgIcon({Key? key,this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(icon!,
        height: Sizes.s20,
        colorFilter: ColorFilter.mode(appCtrl.appTheme.blackColor, BlendMode.srcIn),)
        .paddingAll(Insets.i10)
        .decorated(
        color: appCtrl.appTheme.whiteColor,
        boxShadow: [
          const BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 1,
              color: Color.fromRGBO(0, 0, 0, 0.05))
        ],
        borderRadius:
        BorderRadius.circular(AppRadius.r10));
  }
}
