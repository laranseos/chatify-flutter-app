import '../../../../config.dart';

typedef StringCallback = void Function(int);

class DrawerMenu extends StatelessWidget {
  final bool? value;
final IntCallback? onTap;
final GestureTapCallback? statusTap;
  const DrawerMenu({Key? key, this.value,this.onTap,this.statusTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return Container(
          height: MediaQuery.of(context).size.height,
          width: value! ? Sizes.s450 : Sizes.s70,
          color: appCtrl.isTheme
              ? appCtrl.appTheme.whiteColor
              : const Color(0xFFF7F8FB),
          child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                  crossAxisAlignment: value!
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    UserLayout(onTap: (p0) => onTap!(p0),),
                    Divider(
                        color: appCtrl.appTheme.dividerColor,
                        height: 0,
                        thickness: 1),
                    const VSpace(Sizes.s30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(fonts.status.tr,
                              style: AppCss.poppinsSemiBold20
                                  .textColor(appCtrl.appTheme.blackColor)),
                          Text(fonts.viewAll.tr,
                                  style: AppCss.poppinsMedium16
                                      .textColor(appCtrl.appTheme.primary))
                              .inkWell(onTap: statusTap),
                        ]).marginSymmetric(horizontal: Insets.i40),
                    const VSpace(Sizes.s18),
                    const StatusHorizontal(),
                    Divider(
                            color: appCtrl.appTheme.dividerColor,
                            height: 0,
                            thickness: 1)
                        .marginSymmetric(vertical: Insets.i30),
                    if (indexCtrl.user != null) const MessageLengthLayout(),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(appCtrl.user["id"])
                            .collection(collectionName.chats)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            int number =
                            getUnseenAllMessagesNumber(snapshot.data!.docs);
                            return Text("${fonts.message.tr} (${number.toString()})",
                                    style: AppCss.poppinsSemiBold20
                                        .textColor(appCtrl.appTheme.blackColor))
                                .marginSymmetric(horizontal: Insets.i40);
                          } else {
                            return Text("${fonts.message.tr} (0)",
                                    style: AppCss.poppinsSemiBold20
                                        .textColor(appCtrl.appTheme.blackColor))
                                .marginSymmetric(horizontal: Insets.i40);
                          }
                        }),
                    const VSpace(Sizes.s15),
                    SearchTextBox(
                      onChanged: (val) => indexCtrl.onSearch(val),
                      controller: indexCtrl.userText,
                    ),
                    if (indexCtrl.user != null) const MessageLayout()
                  ])));
    });
  }
}
