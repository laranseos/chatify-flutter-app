

import '../../../../config.dart';

class SettingListCard extends StatelessWidget {
  final dynamic data;
  final int? index;

  const SettingListCard({Key? key, this.data, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (settingCtrl) {
      return
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SvgPicture.asset(
              data["icon"],
            ).paddingAll(Insets.i10).decorated(
                  color: appCtrl.appTheme.white,
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1),
                ),
            const HSpace(Sizes.s10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trans(data["title"]),
                    style: AppCss.poppinsMedium14
                        .textColor(appCtrl.appTheme.blackColor)),
                if (index == 0)
                  Text(
                      appCtrl.languageVal == "en"
                          ? "English"
                          : appCtrl.languageVal == "ar"
                              ? "Arabic"
                              : appCtrl.languageVal == "hi"
                                  ? "Hindi"
                                  : "Gujarati",
                      style: AppCss.poppinsLight12
                          .textColor(appCtrl.appTheme.txtColor)).paddingOnly(top: Insets.i8)
              ],
            )
          ]),
          data["title"] == "rtl" ||
                  data["title"] == "theme" ||
                  data["title"] == "fingerprintLock"
              ? Switch(
                  // This bool value toggles the switch.
                  value: data["title"] == "rtl"
                      ? appCtrl.isRTL
                      : data["title"] == "theme"
                          ? appCtrl.isTheme
                          : appCtrl.isBiometric,
                  activeColor: appCtrl.appTheme.primary,
                  inactiveThumbColor: appCtrl.appTheme.white,inactiveTrackColor: appCtrl.appTheme.gray,
                  onChanged: (bool value) {
                    settingCtrl.onSettingTap(index);
                    appCtrl.update();
                  },
                )
              : SvgPicture.asset(
                      appCtrl.isRTL
                          ? svgAssets.arrowBack
                          : svgAssets.arrowForward,
                      height: Sizes.s10,
                      colorFilter: ColorFilter.mode(appCtrl.appTheme.blackColor, BlendMode.srcIn),)
                  .paddingAll(Insets.i12)
                  .decorated(
                      color: appCtrl.appTheme.txtColor.withOpacity(.1),
                      shape: BoxShape.circle)
                  .inkWell(onTap: () => settingCtrl.onSettingTap(index)),
        ],
      ).marginSymmetric(vertical: Insets.i5).inkWell(onTap: (){});
    });
  }
}
