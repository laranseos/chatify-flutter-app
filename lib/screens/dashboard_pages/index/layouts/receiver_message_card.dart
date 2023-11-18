import 'package:chatify_web/screens/dashboard_pages/index/layouts/sub_title_layout.dart';
import 'package:chatify_web/screens/dashboard_pages/index/layouts/trailing_layout.dart';

import '../../../../config.dart';
import 'image_layout.dart';

class ReceiverMessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;

  const ReceiverMessageCard(
      {Key? key, this.currentUserId, this.blockBy, this.document})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(
        builder: (indexCtrl) {
          return GetBuilder<MessageController>(builder: (msgCtrl) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(document!["receiverId"])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ImageLayout(id: document!["receiverId"]),
                            const HSpace(Sizes.s12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!["name"],
                                    style: AppCss.poppinsblack16
                                        .textColor(
                                        appCtrl.appTheme.blackColor)),
                                const VSpace(Sizes.s5),
                                document!["lastMessage"] != null
                                    ? SubTitleLayout(document: document,
                                  name: snapshot.data!["name"],
                                  blockBy: blockBy,)
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                        TrailingLayout(
                            document: document, currentUserId: currentUserId)
                            .width(Sizes.s55)
                      ],
                    ).width(MediaQuery
                        .of(context)
                        .size
                        .width).paddingSymmetric(horizontal: indexCtrl.chatId == document!["chatId"] ? 0 : Insets.i20,
                        vertical: Insets.i12)
                        .commonDecoration()
                        .marginSymmetric(horizontal:indexCtrl.chatId == document!["chatId"]
                        ? Insets.i10
                        : 0).inkWell(
                        onTap: () {
                          UserContactModel userContact = UserContactModel(
                              username: snapshot.data!["name"],
                              uid: document!["receiverId"],
                              phoneNumber: snapshot.data!["phone"],
                              image: snapshot.data!["image"],
                              isRegister: true);
                          var data = {
                            "chatId": document!["chatId"],
                            "data": userContact,
                            "message":null
                          };
                          indexCtrl.chatId =document!["chatId"];
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
    );
  }
}
