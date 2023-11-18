import '../config.dart';

class CommonNoteEncrypt extends StatelessWidget {
  const CommonNoteEncrypt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Insets.i20,vertical: Insets.i15),
      padding:const EdgeInsets.symmetric(horizontal: Insets.i15,vertical: Insets.i12),
      decoration: ShapeDecoration(
          color: appCtrl.appTheme.blackColor.withOpacity(.09),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
                cornerRadius: 12, cornerSmoothing: 1),
          )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(svgAssets.lock),
          const HSpace(Sizes.s5),
          Expanded(
              child: Text(
                fonts.noteEncrypt.tr,
                textAlign: TextAlign.center,
                style: AppCss.poppinsMedium14
                    .textColor(appCtrl.appTheme.blackColor)
                    .letterSpace(.13).textHeight(1.6),
              )),
        ],
      ),
    );
  }
}
