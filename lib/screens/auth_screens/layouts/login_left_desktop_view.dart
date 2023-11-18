import 'package:smooth_corner/smooth_corner.dart';

import '../../../config.dart';

class LoginLeftDesktopView extends StatelessWidget {
  const LoginLeftDesktopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          imageAssets.loginBg,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        )
            .backgroundColor(appCtrl.appTheme.blackColor)
            .height(MediaQuery.of(context).size.height),
        Column(
          children: [
            SmoothContainer(
              padding: const EdgeInsets.all(Insets.i30),
              margin:const EdgeInsets.symmetric(horizontal: Insets.i120),
              color: const Color.fromRGBO(255, 255, 255, 0.2).withOpacity(.3),
              smoothness: 1,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      fit: BoxFit.fill,
                      child: Row(children: [
                        Container(
                            width: 5,
                            height: Sizes.s50,
                            decoration: BoxDecoration(
                                color: appCtrl.appTheme.primary,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r6))),
                        const HSpace(Sizes.s20),
                        Text(
                            "Without a phone, send and receive messages"
                                .toUpperCase(),
                            style: AppCss.poppinsBold26
                                .textColor(appCtrl.appTheme.white)),
                      ])),
                  const VSpace(Sizes.s20),
                  Text(
                    "If you don’t have a phone don’t worry, Now message with anyone at anytime.",
                    overflow: TextOverflow.clip,
                    style: AppCss.poppinsLight16
                        .textColor(appCtrl.appTheme.white)
                        .textHeight(1.5),
                  )
                ],
              ),
            ),
            const VSpace(Sizes.s35),
            Image.asset(imageAssets.googlePlay, height: Sizes.s65),
          ],
        ).marginOnly(bottom: Insets.i100)
      ],
    ));
  }
}
