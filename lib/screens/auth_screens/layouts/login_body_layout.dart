import 'dart:developer';

import 'package:chatify_web/screens/auth_screens/layouts/country_list.dart';
import 'package:chatify_web/screens/auth_screens/layouts/login_class.dart';
import 'package:country_list_pick/support/code_country.dart';

import '../../../../config.dart';

class LoginBodyLayout extends StatelessWidget {
  const LoginBodyLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneController>(builder: (loginCtrl) {
      return Form(
          key: loginCtrl.formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            LoginCommonClass().logoLayout(image: imageAssets.logo),
            const VSpace(Sizes.s30),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FittedBox(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: Responsive.isMobile(context) ? TextSpan(
                          text: fonts.welcomeBack.tr,
                          style: MediaQuery.of(context).size.width < 1140 ? AppCss.poppinsSemiBold14.textColor(appCtrl.appTheme.blackColor) : AppCss.poppinsSemiBold26
                              .textColor(appCtrl.appTheme.blackColor),
                          children: <TextSpan>[
                            TextSpan(
                                text: " ${fonts.chatify.tr.toLowerCase()} !",
                                style:MediaQuery.of(context).size.width < 1140 ? AppCss.poppinsSemiBold14.textColor(appCtrl.appTheme.blackColor) : AppCss.poppinsSemiBold26
                                    .textColor(appCtrl.appTheme.primary))
                          ]):  TextSpan(
                          text: fonts.welcomeBack.tr,
                          style: MediaQuery.of(context).size.width < 1140 ? AppCss.poppinsSemiBold12.textColor(appCtrl.appTheme.blackColor) : AppCss.poppinsSemiBold26
                              .textColor(appCtrl.appTheme.blackColor),
                          children: <TextSpan>[
                            TextSpan(
                                text: " ${fonts.chatify.tr.toLowerCase()} !",
                                style:MediaQuery.of(context).size.width < 1140 ? AppCss.poppinsSemiBold12.textColor(appCtrl.appTheme.blackColor) : AppCss.poppinsSemiBold26
                                    .textColor(appCtrl.appTheme.primary))
                          ]))),
              const VSpace(Sizes.s8),
              Text(fonts.subtitle.tr,
                  textAlign:TextAlign.start,
                  style: AppCss.poppinsLight16
                      .textColor(appCtrl.appTheme.txtColor).textHeight(1.4))
            ])
                .paddingOnly(left: Insets.i12)
                .border(left: 3, color: appCtrl.appTheme.primary),
            const VSpace(Sizes.s40),
            LoginCommonClass().titleLayout(title: fonts.mobileNumber.tr),
            const VSpace(Sizes.s10),
            //  const PhoneInputBox(),
            IntrinsicHeight(
              child: Row(children: [
                 CountryListLayout(onChanged: (CountryCode? code) {
                   log("CODE : $code");
                   loginCtrl.dialCode = code.toString();
                   loginCtrl.update();
                 },dialCode: loginCtrl.dialCode,),
                const HSpace(Sizes.s10),
                Expanded(
                    child: CommonTextBox(
                        keyboardType: TextInputType.number,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(AppRadius.r8)),
                        controller: loginCtrl.phone,
                        filled: true,
                        hinText: "Enter your mobile number",
                        fillColor: appCtrl.appTheme.txtColor.withOpacity(.10)))
              ]),
            ),
            const VSpace(Sizes.s10),
            if (loginCtrl.mobileNumber)
              AnimatedOpacity(
                  duration: const Duration(seconds: 3),
                  opacity: loginCtrl.mobileNumber ? 1.0 : 0.0,
                  child: Text(fonts.phoneError.tr,
                          style: AppCss.poppinsMedium12
                              .textColor(appCtrl.appTheme.redColor))
                      .alignment(Alignment.centerRight)),
            const VSpace(Sizes.s30),
            CommonButton(
                title: "Send Verification Code",
                margin: 0,
                verticalPadding: Insets.i16,
                onTap: () => loginCtrl.checkValidation(),
                padding: 0,

                style:
                    AppCss.poppinsMedium14.textColor(appCtrl.appTheme.white)),
            const VSpace(Sizes.s20),
            Text("Send an SMS code to verify your number",
                    textAlign: TextAlign.center,
                    style: AppCss.poppinsLight14
                        .textColor(appCtrl.appTheme.txtColor))
                .alignment(Alignment.center),
                const VSpace(Sizes.s20),
                RichText(
                    text:TextSpan(
                      text: "NOTE : ",
                  style: AppCss.poppinsblack14.textColor(appCtrl.appTheme.redColor).textHeight(1.5),
                  children: [
                    TextSpan(
                      text: "For Mobile Web Access Firstly You Need To Register Your App From Mobile Device For Contact Sync In Web",
                      style: AppCss.poppinsBold14.textColor(appCtrl.appTheme.blackColor).textHeight(1.5)
                    )
                  ]
                ) )
          ]));
    });
  }
}
