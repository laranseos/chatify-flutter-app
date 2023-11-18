import '../../../../config.dart';

class LoginCommonClass {
  //login body
  Widget loginBody({Widget? child}) => Center(
      child: Container(

          margin: const EdgeInsets.symmetric(horizontal: Insets.i15),
          child: child));

  //logo layout
  Widget logoLayout({String? image}) => Image.asset(image!,
      height: Responsive.isMobile(Get.context!) ?Sizes.s30 : Sizes.s45);

  //title layout
  Widget titleLayout({String? title}) => Text(title.toString().tr,
          style: AppCss.poppinsRegular18.textColor(appCtrl.appTheme.txt))
      .alignment(Alignment.centerLeft);

  //forgot password
  Widget forgotPassword() => IntrinsicHeight(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Icon(Icons.lock,
                size: Sizes.s15, color: appCtrl.appTheme.blackColor),
            const HSpace(Sizes.s5),
            Text(fonts.forgotPassword.tr,
                style:
                    AppCss.poppinsblack16.textColor(appCtrl.appTheme.blackColor))
          ]));
}
