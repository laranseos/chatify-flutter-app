
import 'dart:developer';

import 'package:chatify_web/screens/auth_screens/layouts/login_body_layout.dart';

import '../../../../config.dart';
import 'login_class.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("WIDTH : ${MediaQuery.of(context).size.width}");
    return LoginCommonClass().loginBody(
        child: Container(
          width:  Responsive.isMobile(context)  ?MediaQuery.of(context).size.width :MediaQuery.of(context).size.width / 3,

            padding: EdgeInsets.symmetric(vertical:Responsive.isMobile(context) ? 0: Insets.i50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r10),
                color: appCtrl.appTheme.bgColor,boxShadow:const [BoxShadow(
              color: Color.fromRGBO(49, 100, 189, 0.08),blurRadius: 12, spreadRadius: 2
            )]),
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal:Insets.i50,vertical: Insets.i20),
                child: SingleChildScrollView(child: LoginBodyLayout()))));
  }
}
