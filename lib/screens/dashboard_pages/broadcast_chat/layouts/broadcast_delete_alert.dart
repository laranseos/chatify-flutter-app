

import '../../../../config.dart';

class BroadCastDeleteAlert extends StatelessWidget {
  final DocumentSnapshot? documentReference;

  const BroadCastDeleteAlert({Key? key, this.documentReference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      return AlertDialog(
        backgroundColor: appCtrl.appTheme.whiteColor,
        title: Text(fonts.alert.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(fonts.areYouSureToDelete.tr),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(fonts.close.tr),
          ),
          TextButton(
            onPressed: () async {
               Get.back();
                FirebaseFirestore.instance
                    .collection(collectionName.broadcastMessage).doc(chatCtrl.pId).collection(collectionName.chat)
                    .doc(documentReference!.id)
                    .delete();
                await FirebaseFirestore.instance
                    .runTransaction((transaction) async {});
                chatCtrl.listScrollController.animateTo(0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);

              await FirebaseFirestore.instance
                  .collection(collectionName.broadcastMessage)
                  .doc(chatCtrl.pId)
                  .collection(collectionName.chat)
                  .orderBy("timestamp", descending: true)
                  .limit(1)
                  .get()
                  .then((value) {
                if(value.docs.isEmpty){
                  FirebaseFirestore.instance
                      .collection(collectionName.users).doc(chatCtrl.userData["id"]).collection(collectionName.chats)
                      .where("chatId", isEqualTo: chatCtrl.chatId)
                      .get()
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection(collectionName.users).doc(chatCtrl.userData["id"]).collection(collectionName.chats).doc(value.docs[0].id).delete();
                  });
                }else {
                  FirebaseFirestore.instance
                      .collection(collectionName.users).doc(chatCtrl.userData["id"]).collection(collectionName.chats)
                      .where("chatId", isEqualTo: chatCtrl.chatId)
                      .get()
                      .then((snapShot) {
                    if (snapShot.docs.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection(collectionName.users).doc(chatCtrl.userData["id"]).collection(collectionName.chats)
                          .doc(snapShot.docs[0].id)
                          .update({
                        "updateStamp":
                        DateTime
                            .now()
                            .millisecondsSinceEpoch
                            .toString(),
                        "lastMessage": value.docs[0].data()["content"],
                        "senderId": value.docs[0].data()["senderId"],
                        'sender': {
                          "id": value.docs[0].data()["sender"]['id'],
                          "name": value.docs[0].data()["sender"]['name'],
                          "image": value.docs[0].data()["sender"]["image"]
                        },
                        "receiverId": value.docs[0].data()["receiverId"],
                        "receiver": {
                          "id": value.docs[0].data()["receiver"]["id"],
                          "name": value.docs[0].data()["receiver"]["name"],
                          "image": value.docs[0].data()["receiver"]["image"]
                        }
                      });
                    }
                  });
                }
              });
            },
            child: Text(fonts.yes.tr),
          ),
        ],
      );
    });
  }
}
