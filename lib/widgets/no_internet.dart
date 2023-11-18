import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:chatify_web/config.dart';


class NoInternet extends StatelessWidget {
  final ConnectivityResult? connectionStatus;
  const NoInternet({Key? key,this.connectionStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          log("snapshot.data : ${ snapshot.data == ConnectivityResult.none || snapshot.data == null}");
          if(snapshot.data != ConnectivityResult.none || snapshot.data != null){
            final splashCtrl = Get.find<SplashController>();
            splashCtrl.onReady();
          }
        return snapshot.data == ConnectivityResult.none || snapshot.data == null? Scaffold(
          backgroundColor: appCtrl.appTheme.whiteColor,
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageAssets.noInternet),
              const VSpace(Sizes.s10),
              Text(fonts.noInternet.tr,style: AppCss.poppinsMedium18.textColor(appCtrl.appTheme.blackColor),)

            ],
          )),
        ) :Container();
      }
    );
  }
}
