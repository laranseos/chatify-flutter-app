import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final double padding;
  final double margin,verticalMargin,horizontalPadding,verticalPadding;
  final double radius;
  final double height;
  final double fontSize;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final Color? color;
  final Color? fontColor;
  final Widget? icon;
  final double? width;
  final Border? border;
  final FontWeight? fontWeight;
  final Gradient? gradient;

  const CommonButton(
      {Key? key,
      required this.title,
      this.padding = 15,
      this.margin = 15,
      this.verticalMargin = 15,
      this.radius = 5,
      this.horizontalPadding = 5,
      this.verticalPadding = 5,
      this.height = 45,
      this.fontSize = FontSizes.f14,
      this.onTap,
      this.style,
      this.color,
      this.fontColor,
      this.icon,
      this.width,
      this.border,
      this.fontWeight = FontWeight.w700,
      this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SmoothContainer(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding,vertical: verticalPadding),
          width: width ?? MediaQuery.of(context).size.width,
          smoothness: 1,
          color: color ?? appCtrl.appTheme.primary,
          margin: EdgeInsets.symmetric(horizontal: margin,vertical: verticalMargin),
          borderRadius: BorderRadius.circular(12),
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (icon != null)
          Row(children: [icon ?? const HSpace(0), const HSpace(10)]),
                Text(title, textAlign: TextAlign.center, style: style)
              ])),
    );
  }
}
