
import 'package:chatify_web/config.dart';

extension CommonExtension on Widget{
  // decoration
  Widget  commonDecoration({isSelected = false}) => Container(child: this).decorated(
      color: isSelected  ?appCtrl.appTheme.white : appCtrl.appTheme.transparentColor,
      borderRadius: BorderRadius.circular(AppRadius.r10),
      );
}