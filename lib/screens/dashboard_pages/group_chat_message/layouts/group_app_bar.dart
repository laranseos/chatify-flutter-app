import '../../../../config.dart';

class GroupChatMessageAppBar extends StatelessWidget {
  const GroupChatMessageAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonImage(
                    image: chatCtrl.pData["image"],
                    name: chatCtrl.pName,
                    height: Sizes.s60,
                    width: Sizes.s60),
                const HSpace(Sizes.s8),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chatCtrl.pName ?? "",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppCss.poppinsSemiBold14
                            .textColor(appCtrl.appTheme.blackColor),
                      ),
                      const VSpace(Sizes.s6),
                      const GroupUserLastSeen()
                    ]).marginSymmetric(vertical: Insets.i2)
              ],
            ).inkWell(onTap: (){
              chatCtrl.isUserProfile =true;
              chatCtrl.update();
            }),
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
                    onSelected: (result)async {
                      if(result ==1){
                        List userId = [];
                        chatCtrl.clearChatId.add(chatCtrl.user["id"]);
                        chatCtrl.update();
                        await FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(chatCtrl.user["id"])
                            .collection(collectionName.chats)
                            .where("groupId", isEqualTo: chatCtrl.pId)
                            .limit(1)
                            .get()
                            .then((value) async {
                          if (value.docs.isNotEmpty) {
                            userId = value.docs[0].data()["clearChatId"] ?? [];
                            userId.add(chatCtrl.user["id"]);
                            await FirebaseFirestore.instance
                                .collection(collectionName.users)
                                .doc(chatCtrl.user["id"])
                                .collection(collectionName.chats)
                                .doc(value.docs[0].id)
                                .update({"clearChatId": userId});
                          }
                        }).then((value) async {
                          await FirebaseFirestore.instance
                              .collection(collectionName.groups)
                              .where("groupId", isEqualTo: chatCtrl.pId)
                              .limit(1)
                              .get()
                              .then((group) async {
                            await FirebaseFirestore.instance
                                .collection(collectionName.groups)
                                .doc(group.docs[0].id)
                                .update({"clearChatId": userId});
                          });
                        });
                      }else if(result ==2){
                        chatCtrl.isThere
                            ? chatCtrl.exitGroupDialog()
                            : chatCtrl.deleteGroup();
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    itemBuilder: (ctx) => [

                          _buildPopupMenuItem(fonts.clearChat.tr, 1),
                          _buildPopupMenuItem(chatCtrl.isThere
                              ? fonts.exitGroup.tr
                              : fonts.deleteGroup.tr, 2),
                        ]))
          ]).marginSymmetric(horizontal: Insets.i40, vertical: Insets.i30),
          Divider(
              color: appCtrl.appTheme.dividerColor,
              height: 0,
              thickness: 1).marginSymmetric(horizontal: Insets.i30)
        ],
      );
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
          ),
        ],
      ),
    );
  }
}
