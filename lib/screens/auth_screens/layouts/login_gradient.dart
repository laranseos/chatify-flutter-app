// linear gradient
import '../../../../config.dart';

LinearGradient commonLinearGradient() => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      appCtrl.appTheme.whiteColor.withOpacity(0.5),
      appCtrl.appTheme.whiteColor.withOpacity(0.5)
    ]);

//background linear gradient
LinearGradient backgroundLinearGradient() => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      appCtrl.appTheme.whiteColor.withOpacity(0.1),
      appCtrl.appTheme.whiteColor.withOpacity(0.05)
    ],
    stops: const [
      0.1,
      1
    ]);

// login background linear gradient
LinearGradient loginLinearGradient() => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      appCtrl.appTheme.bgColor,
      appCtrl.appTheme.bgColor,
      appCtrl.appTheme.bgColor,
    ],
    stops: const [
      0.1,
      .3,
      1
    ]);
