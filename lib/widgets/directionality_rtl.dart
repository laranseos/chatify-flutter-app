import '../config.dart';

class DirectionalityRtl extends StatelessWidget {
  final Widget? child;
  const DirectionalityRtl({Key? key,this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: appCtrl.isRTL || appCtrl.languageVal == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: child!);
  }
}
