
import 'package:chatify_web/screens/dashboard_pages/profile_setting/layouts/edit_profile_text_box.dart';


import '../../../../config.dart';

class IndexDrawer extends StatelessWidget {

  final profileCtrl = Get.put(EditProfileController());

  final GestureTapCallback? onTap;
   IndexDrawer({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return GetBuilder<EditProfileController>(
        builder: (_) {
          return ValueListenableBuilder<bool>(
              valueListenable: indexCtrl.drawerIndex,
              builder: (context, value, child) {

                return AnimatedContainer(
                  duration: Duration(seconds: !value ? 1 :0),
                  height: MediaQuery.of(context).size.height,
                  width: !value ? Sizes.s450 : 0,
                    color: appCtrl.isTheme ?appCtrl.appTheme.whiteColor : const Color(0xFFEFF3F9),
                  child: Form(
                    key: profileCtrl.formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                        Row(mainAxisSize: MainAxisSize.min, children: [
                           BackIcon(onTap: onTap),
                          const HSpace(Sizes.s20),
                          Text(fonts.profileSetting.tr,
                              style: AppCss.poppinsblack22
                                  .textColor(appCtrl.appTheme.blackColor))
                        ])
                            .width(!value ? Sizes.s450 : 0)
                            .paddingOnly(top: Insets.i30,left: Insets.i40),
                      Divider(color: appCtrl.appTheme.dividerColor),
                      const VSpace(Sizes.s20),
                      Stack(
                        children: [
                          CommonImage(
                              image: appCtrl.user["image"] ??"",
                              name: appCtrl.user["name"],
                              height: Sizes.s130,
                              width: Sizes.s130),

                          Positioned(
                            bottom: 10,
                            right: -1,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: SvgPicture.asset(svgAssets.edit,
                                    height: Sizes.s16)
                                    .paddingAll(Insets.i6)
                                    .decorated(
                                    color: appCtrl.appTheme.primary,
                                    shape: BoxShape.circle))
                                .paddingAll(Insets.i2)
                                .decorated(
                                color: appCtrl.appTheme.white,
                                shape: BoxShape.circle),
                          )
                        ],
                      ).width(Sizes.s140).height(Sizes.s150).alignment(Alignment.center),
                      Divider(color: appCtrl.appTheme.dividerColor,height: 0).marginSymmetric(vertical: Insets.i20),

                      Column(
                        children: [
                          const EditProfileTextBox(),

                          CommonButton(
                              title: fonts.saveProfile.tr,
                              margin: 0,
                              radius: AppRadius.r12,
                              verticalPadding: Insets.i16,
                              onTap: () {
                                if (profileCtrl.formKey.currentState!.validate()) {
                                  profileCtrl.updateUserData();
                                } else {}
                              },
                              style: AppCss.poppinsblack14.textColor(appCtrl.appTheme.whiteColor))
                        ],
                      ).marginSymmetric(horizontal: Insets.i25)
                    ]) .width(!value ? Sizes.s450 : 0),
                  )
                );
              });
        }
      );
    });
  }
}
