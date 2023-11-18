
import 'package:chatify_web/screens/auth_screens/layouts/otp_body_layout.dart';

import '../../../../config.dart';
import 'login_class.dart';

class OtpLayout extends StatelessWidget {
  final String? phone,dialCode;
  const OtpLayout({Key? key,this.phone,this.dialCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginCommonClass().loginBody(
        child: Container(
          margin: const EdgeInsets.only(top: 50),
            width:  Responsive.isMobile(context)  ?MediaQuery.of(context).size.width :MediaQuery.of(context).size.width / 3,
            padding:const EdgeInsets.symmetric(vertical: Insets.i20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r10),
                color: appCtrl.appTheme.bgColor,boxShadow:const [BoxShadow(
              color: Color.fromRGBO(49, 100, 189, 0.08),blurRadius: 12, spreadRadius: 2
            )]),
            child:  Padding(
                padding:const EdgeInsets.symmetric(horizontal:Insets.i50,vertical: Insets.i20),
                child: SingleChildScrollView(child: OtpBodyLayout(dialCode: dialCode,phone: phone,)))));
  }
}
