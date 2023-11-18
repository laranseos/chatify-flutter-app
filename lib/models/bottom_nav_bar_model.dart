import '../../../../config.dart';

class BottomNavyBarItem {

  BottomNavyBarItem({
    required this.icon,
    required this.title,
    this.activeColor,
    this.textAlign,
    this.inactiveColor,
  });

  final Widget icon;
  final Widget title;
  final Color? activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;

}