import 'package:chatify_web/screens/dashboard_pages/index/layouts/message_card_sub_title.dart';
import 'package:chatify_web/screens/dashboard_pages/index/layouts/trailing_layout.dart';
import '../../../../config.dart';
import 'image_layout.dart';

class MessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;

  const MessageCard({Key? key, this.document, this.currentUserId, this.blockBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(document!["senderId"])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    ImageLayout(
                      id: document!["senderId"],
                    ),
                    const HSpace(Sizes.s12),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!["name"],
                              style: AppCss.poppinsblack16
                                  .textColor(appCtrl.appTheme.blackColor)),
                          const VSpace(Sizes.s6),
                          document!["lastMessage"] != null
                              ? decryptMessage(document!["lastMessage"])
                                      .contains(".gif")
                                  ? const Icon(Icons.gif_box)
                                  : MessageCardSubTitle(
                                      blockBy: blockBy,
                                      name: snapshot.data!["name"],
                                      document: document,
                                      currentUserId: currentUserId)
                              : Container()
                        ])
                  ]),
                  Expanded(
                      child: TrailingLayout(
                          currentUserId: currentUserId, document: document))
                ],
              )
                  .width(MediaQuery.of(context).size.width)
                  .paddingSymmetric(
                      horizontal: indexCtrl.chatId == document!["chatId"]
                          ? 0
                          : Insets.i24,
                      vertical: Insets.i10)
                  .commonDecoration()
                  .marginSymmetric(
                      horizontal: indexCtrl.chatId == document!["chatId"]
                          ? Insets.i10
                          : 0)
                  .inkWell(onTap: () {
                UserContactModel userContact = UserContactModel(
                    username: snapshot.data!["name"],
                    uid: document!["senderId"],
                    phoneNumber: snapshot.data!["phone"],
                    image: snapshot.data!["image"],
                    isRegister: true);
                var data = {
                  "chatId": document!["chatId"],
                  "data": userContact,
                  "message": null
                };
                indexCtrl.chatId = document!["chatId"];
                indexCtrl.chatType = 0;
                indexCtrl.update();
                final chatCtrl = Get.isRegistered<ChatController>()
                    ? Get.find<ChatController>()
                    : Get.put(ChatController());

                chatCtrl.data = data;

                chatCtrl.update();
                chatCtrl.onReady();
              });
            }
          });
    });
  }
}
