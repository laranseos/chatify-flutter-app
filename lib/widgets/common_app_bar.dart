
import '../config.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  const CommonAppBar({Key? key,this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      backgroundColor: appCtrl.appTheme.bgColor,
      automaticallyImplyLeading: false,
      leadingWidth: Sizes.s80,
      titleSpacing: 0,
      toolbarHeight: Sizes.s80,
      elevation: 0,
      leading:const BackIcon(),
      centerTitle: true,
      title: Text(text!,
          style: AppCss.poppinsSemiBold16
              .textColor(appCtrl.appTheme.primary)
              .letterSpace(.2)),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(Sizes.s80);
}
