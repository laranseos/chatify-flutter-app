import 'package:chatify_web/screens/dashboard_pages/index/layouts/image_layout.dart';

import '../../../../config.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return GetBuilder<IndexController>(builder: (indexCtrl) {
        return Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImageLayout(id: chatCtrl.pId, isImageLayout: true),
                      const HSpace(Sizes.s20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              chatCtrl.pName ?? "",
                              textAlign: TextAlign.center,
                              style: AppCss.poppinsSemiBold14
                                  .textColor(appCtrl.appTheme.blackColor),
                            ),
                            const VSpace(Sizes.s12),
                            const UserLastSeen()
                          ]).marginSymmetric(vertical: Insets.i2)
                    ],
                  ).inkWell(onTap: (){
                    chatCtrl.isUserProfile = true;
                    chatCtrl.update();
                  }),
                  Row(
                    children: [

                      Container(
                          width: Sizes.s40,
                          height: Sizes.s40,
                          decoration: ShapeDecoration(
                              color: appCtrl.appTheme.white,
                              shadows: const [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.08))
                              ],
                              shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 10, cornerSmoothing: .8))),
                          child: PopupMenuButton(
                              color: appCtrl.appTheme.whiteColor,
                              icon: SvgPicture.asset(
                                svgAssets.moreVertical,
                              ),
                              onSelected: (result) async {
                                if (result == 0) {
                                  await FirebaseFirestore.instance
                                      .collection(collectionName.users)
                                      .doc(appCtrl.user["id"])
                                      .collection(collectionName.chats)
                                      .where("chatId", isEqualTo: chatCtrl.pId)
                                      .get()
                                      .then((value) async {
                                    await FirebaseFirestore.instance
                                        .collection(collectionName.users)
                                        .doc(appCtrl.user["id"])
                                        .collection(collectionName.chats)
                                        .doc(value.docs[0].id)
                                        .delete();
                                  });
                                  indexCtrl.chatId = null;
                                  indexCtrl.update();
                                } else if (result == 1) {
                                  await FirebaseFirestore.instance
                                      .collection(collectionName.users)
                                      .doc(chatCtrl.userData["id"])
                                      .collection(collectionName.chats)
                                      .where("chatId", isEqualTo: chatCtrl.chatId)
                                      .limit(1)
                                      .get()
                                      .then((value) async {
                                    if (value.docs.isNotEmpty) {
                                      List userId =
                                          value.docs[0].data()["clearChatId"] ?? [];
                                      chatCtrl.clearChatId.add(chatCtrl.userData["id"]);
                                      userId.add(chatCtrl.userData["id"]);
                                      await FirebaseFirestore.instance
                                          .collection(collectionName.users)
                                          .doc(chatCtrl.userData["id"])
                                          .collection(collectionName.chats)
                                          .doc(value.docs[0].id)
                                          .update({"clearChatId": userId});
                                    }
                                  });
                                } else if (result == 2) {
                                  chatCtrl.blockUser();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.r8),
                              ),
                              itemBuilder: (ctx) => [
                                    _buildPopupMenuItem(fonts.deleteChat.tr, 0),
                                    _buildPopupMenuItem(fonts.clearChat.tr, 1),
                                    _buildPopupMenuItem(
                                        chatCtrl.isBlock
                                            ? fonts.unblock.tr
                                            : fonts.block.tr,
                                        2),
                                  ])),
                    ],
                  )
                ]).marginSymmetric(horizontal: Insets.i40, vertical: Insets.i30),
            Divider(
                color: appCtrl.appTheme.dividerColor,
                height: 0,
                thickness: 1).marginSymmetric(horizontal: Insets.i30)
          ],
        );
      });
    });
  }

  PopupMenuItem _buildPopupMenuItem(String title, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Text(
            title,
            style:
                AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor),
          )
        ],
      ),
    );
  }
}
