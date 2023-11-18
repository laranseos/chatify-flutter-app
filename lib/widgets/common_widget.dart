import 'package:chatify_web/config.dart';

class CommonWidget{
  //back icon
  Widget backIcon() =>  Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(imageAssets.back,
          height: Insets.i20,
          width: Insets.i20,
          fit: BoxFit.cover)
          .inkWell(onTap: () => Get.back()))
      .paddingOnly(top: Insets.i20, left: Insets.i20);
}