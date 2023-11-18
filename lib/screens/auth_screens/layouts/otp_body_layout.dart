import 'package:chatify_web/screens/auth_screens/layouts/login_class.dart';
import 'package:flutter/gestures.dart';


import '../../../../config.dart';
import 'otp_input.dart';

class OtpBodyLayout extends StatelessWidget {
final String? phone,dialCode;
  const OtpBodyLayout({Key? key,this.dialCode,this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(
        builder: (otpCtrl) {
          String strDigits(int n) => n.toString().padLeft(2, '0');
          final seconds = strDigits(otpCtrl.myDuration.inSeconds.remainder(60));
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginCommonClass().logoLayout(image: imageAssets.logo),
                  const VSpace(Sizes.s30),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FittedBox(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "Welcome Back ",
                                style: AppCss.poppinsMedium26
                                    .textColor(appCtrl.appTheme.blackColor),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "chatify!",
                                      style: AppCss.poppinsMedium26
                                          .textColor(appCtrl.appTheme.primary))
                                ]))),
                    const VSpace(Sizes.s8),
                    Text("OTP Verification!",
                        textAlign: TextAlign.center,
                        style: AppCss.poppinsLight16
                            .textColor(appCtrl.appTheme.txtColor))
                  ])
                      .paddingOnly(left: Insets.i12)
                      .border(left: 3, color: appCtrl.appTheme.primary),
                  const VSpace(Sizes.s40),
                  LoginCommonClass().titleLayout(title: "Enter Code From SMS"),
                  const VSpace(Sizes.s10),
                  const OtpInput(),
                  const VSpace(Sizes.s18),
                  Text("Enter SMS code sent to - ${otpCtrl.dialCodeVal} ${otpCtrl.mobileNumber}",
                      textAlign: TextAlign.center,
                      style:
                      AppCss.poppinsLight14.textColor(appCtrl.appTheme.txtColor)).alignment(Alignment.center),
                  const VSpace(Sizes.s70),
                  CommonButton(
                      title: "Verify",
                      margin: 0,
                      onTap: () => otpCtrl.onFormSubmitted(),
                      padding: 0,
                      verticalPadding: Insets.i16,
                      style:
                      AppCss.poppinsMedium14.textColor(appCtrl.appTheme.white)),
                  const VSpace(Sizes.s20),

                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                        textAlign: TextAlign.center,

                        text: TextSpan(
                            text: "Your OTP will expire after ",
                            recognizer:  TapGestureRecognizer()
                              ..onTap = () { otpCtrl.onVerifyCode(phone, dialCode);
                              },
                            style: AppCss.poppinsMedium16
                                .textColor(appCtrl.appTheme.txtColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: seconds,
                                  style: AppCss.poppinsMedium16
                                      .textColor(appCtrl.appTheme.primary)),
                              TextSpan(
                                  text: " seconds",
                                  style: AppCss.poppinsMedium16
                                      .textColor(appCtrl.appTheme.txtColor))
                            ])),
                  ),
                  const VSpace(Sizes.s15),

                ],
              ),
              Text("Back To SignIn Screen",textAlign: TextAlign.center,style: AppCss.poppinsMedium18.textColor(appCtrl.appTheme.blackColor),).inkWell(
                  onTap: (){
                    final phoneCtrl = Get.isRegistered<PhoneController>()
                        ? Get.find<PhoneController>()
                        : Get.put(PhoneController());
                    phoneCtrl.isOtp = false;
                    phoneCtrl.update();
                  }
              )
            ],
          );
        }
    );
  }
}
