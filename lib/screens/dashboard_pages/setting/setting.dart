import 'package:smooth_corner/smooth_corner.dart' as smooth;

import '../../../config.dart';


class Setting extends StatelessWidget {
  final settingCtrl = Get.put(SettingController());

  final GestureTapCallback? onTap;
  Setting({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return GetBuilder<SettingController>(builder: (context2) {
        return ValueListenableBuilder<bool>(
            valueListenable: indexCtrl.settingIndex,
            builder: (context1, value, child) {
              if (!value) {
                indexCtrl.textShow();
              }
              return AnimatedContainer(
                duration: Duration(seconds: !value ? 1 : 0),
                height: MediaQuery.of(context).size.height,
                width: !value ? Sizes.s450 : 0,
                color: appCtrl.isTheme
                    ? appCtrl.appTheme.whiteColor
                    : const Color(0xFFF7F8FB),
                child: Column(children: [
                  if (!value)
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      BackIcon(onTap: onTap),
                      const HSpace(Sizes.s20),
                      Text(fonts.setting.tr,
                          style: AppCss.poppinsblack22
                              .textColor(appCtrl.appTheme.blackColor))
                    ])
                        .width(!value ? Sizes.s450 : 0)
                        .paddingOnly(top: Insets.i45),
                  Divider(color: appCtrl.appTheme.dividerColor),
                  const VSpace(Sizes.s20),
                  if (!value)
                    Container(
                      padding: const EdgeInsets.all(Insets.i15),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                          shadows: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 15,
                                spreadRadius: 0,
                                color:
                                    appCtrl.appTheme.primary.withOpacity(.08))
                          ],
                          shape: smooth.SmoothRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              smoothness: 0.9),
                          color: appCtrl.appTheme.whiteColor),
                      child: Row(children: [
                        CommonImage(
                            image: appCtrl.user["image"] ??"",
                            name: appCtrl.user["name"],
                            height: Sizes.s68,
                            width: Sizes.s68),
                        const HSpace(Sizes.s12),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(settingCtrl.user["name"],
                                  style: AppCss.poppinsblack22
                                      .textColor(appCtrl.appTheme.blackColor)),
                              const VSpace(Sizes.s10),
                              Text(appCtrl.user["statusDesc"],
                                  style: AppCss.poppinsLight14
                                      .textColor(appCtrl.appTheme.txtColor))
                            ])
                      ]),
                    ),
                  const VSpace(Sizes.s35),
                  if (!value)
                    //setting list
                    ...settingCtrl.settingList
                        .asMap()
                        .entries
                        .map((e) => Column(children: [
                              SettingListCard(index: e.key, data: e.value),
                              if (e.key != settingCtrl.settingList.length - 1)
                                Divider(
                                        color: appCtrl.appTheme.dividerColor,
                                        thickness: 1,
                                        height: 0)
                                    .paddingSymmetric(vertical: Insets.i15)
                            ]))
                        .toList()
                ]).paddingSymmetric(horizontal: Insets.i20),
              );
            });
      });
    });
  }
}
