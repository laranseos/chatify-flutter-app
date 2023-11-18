import 'dart:developer';

import '../../../../config.dart';


class LeadingRow extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldDrawerKey;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const LeadingRow({Key? key, this.scaffoldKey, this.scaffoldDrawerKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return Row(children: [
        ValueListenableBuilder<bool>(
            valueListenable: indexCtrl.isOpen,
            builder: (context, value, child) {
              if (Responsive.isDesktop(context) && value) {
                return InkWell(
                    onTap: () {
                      log("message");
                    },
                    child: Container(
                      width: Sizes.s450,
                      padding:const EdgeInsets.symmetric(vertical: Insets.i10),
                      color: const Color.fromRGBO(49, 100, 189, 0.03),
                      child: Image.asset(
                        imageAssets.logo,
                        width: Sizes.s240,

                      ),
                    ));
              }
              return InkWell(
                  onTap: () {
                    scaffoldDrawerKey!.currentState?.closeDrawer();
                  },
                  child: Responsive.isDesktop(context)
                      ? Container(
                          width: Sizes.s70,
                          padding: const EdgeInsets.all(Insets.i10),
                      color: const Color.fromRGBO(49, 100, 189, 0.03),
                          height: double.infinity,
                          child: Image.asset(imageAssets.logo,
                              fit: BoxFit.contain))
                      : Container());
            }),

      ]);
    });
  }
}
