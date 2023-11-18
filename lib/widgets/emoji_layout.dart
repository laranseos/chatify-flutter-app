import '../config.dart';

class EmojiLayout extends StatelessWidget {
  final String? emoji;
  const EmojiLayout({Key? key,this.emoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: -15,
        child: Text(emoji!,style: AppCss.poppinsLight12,)
            .paddingAll(Insets.i6)
            .decorated(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: appCtrl.appTheme.emojiShadowColor,
                  blurRadius: 2,spreadRadius: 2
              )
            ],
            color: appCtrl.appTheme.whiteColor).paddingSymmetric(horizontal: Insets.i15));
  }
}
