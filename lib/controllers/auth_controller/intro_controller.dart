import 'dart:async';
import 'dart:developer';

import 'package:chatify_web/config.dart';

class IntroController extends GetxController {
  var pageController = PageController(initialPage: 0);
  List pageViewModelData = [];
  final storage = GetStorage();
  var intro1 = fonts.intro1;
  var intro2 = fonts.intro2;
  var intro3 = fonts.intro3;
  var introDesc1 = fonts.introDesc1;
  var introDesc2 = fonts.introDesc2;
  var introDesc3 = fonts.introDesc3;
  bool isAnimate1 = false;
  bool isAnimate2 = false;
  bool isAnimate3 = false;
  late Timer sliderTimer;
  var currentShowIndex = 0;

  @override
  void onReady() {
    // TODO: implement onReady
    pageViewModelData.add(PageViewData(
      titleText: intro1,
      subtitleText: fonts.introDesc1,
      assetsImage: svgAssets.intro1,
    ));

    pageViewModelData.add(PageViewData(
      titleText: intro2,
      subtitleText: fonts.introDesc2,
      assetsImage: svgAssets.intro2,
    ));

    pageViewModelData.add(PageViewData(
      titleText: intro3,
      subtitleText: fonts.introDesc3,
      assetsImage: svgAssets.intro3,
    ));

    // set timer and page controller according to current Index
    sliderTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (currentShowIndex == 0) {
        pageController.animateTo(MediaQuery.of(Get.context!).size.width,
            duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 1) {
        pageController.animateTo(MediaQuery.of(Get.context!).size.width * 2,
            duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 2) {
        pageController.animateTo(0,
            duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
      }
    });
    update();
    super.onReady();
  }

//navigate to Login
  navigateToLogin() async{
    await storage.write(session.isIntro, true);
    Get.toNamed(routeName.phone);
    log("isIntro : ${storage.read(session.isIntro)}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sliderTimer.cancel();
    pageController.dispose();

    update();
    super.dispose();
  }
}
