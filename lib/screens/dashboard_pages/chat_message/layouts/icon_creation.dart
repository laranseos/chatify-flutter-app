import '../../../../../../config.dart';

class IconCreation extends StatelessWidget {
  final IconData? icons;
  final Color? color;
  final String? text;
  final GestureTapCallback? onTap;
  const IconCreation({Key? key,this.text,this.color,this.icons,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: AppRadius.r30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: Sizes.s30,
              color: appCtrl.appTheme.whiteColor,
            ),
          ),
          const VSpace(Sizes.s8),
          Text(
            text!,
            style: AppCss.poppinsblack14.textColor(appCtrl.appTheme.blackColor),
          )
        ],
      ),
    );
  }
}
