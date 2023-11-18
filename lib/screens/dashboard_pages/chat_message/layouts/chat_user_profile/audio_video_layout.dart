import '../../../../../config.dart';

class AudioVideoButtonLayout extends StatelessWidget {
  final GestureTapCallback? callTap, videoTap, addTap;
  final bool isGroup;

  const AudioVideoButtonLayout(
      {Key? key,
      this.callTap,
      this.videoTap,
      this.isGroup = false,
      this.addTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(children: [
        SvgPicture.asset(svgAssets.call,
            height: Sizes.s18, colorFilter: ColorFilter.mode(appCtrl.appTheme.primary, BlendMode.srcIn),),
        const VSpace(Sizes.s10),
        Text(fonts.audio.tr,
            style: AppCss.poppinsMedium12.textColor(appCtrl.appTheme.txtColor))
      ])
          .paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i12)
          .decorated(
              color: appCtrl.appTheme.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.r10),
              boxShadow: [
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                spreadRadius: 2,
                blurRadius: 12)
          ]).inkWell(onTap: callTap),
      const HSpace(Sizes.s15),
      Column(
        children: [
          SvgPicture.asset(svgAssets.video,
              height: Sizes.s18,colorFilter: ColorFilter.mode(appCtrl.appTheme.primary, BlendMode.srcIn)),
          const VSpace(Sizes.s10),
          Text(fonts.video.tr,
              style:
                  AppCss.poppinsMedium12.textColor(appCtrl.appTheme.txtColor))
        ],
      )
          .paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i12)
          .decorated(
              color: appCtrl.appTheme.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.r10),
              boxShadow: [
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                spreadRadius: 2,
                blurRadius: 12)
          ]).inkWell(onTap: videoTap),
      const HSpace(Sizes.s15),

    ]);
  }
}
