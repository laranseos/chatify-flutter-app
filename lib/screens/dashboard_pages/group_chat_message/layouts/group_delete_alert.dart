import '../../../../config.dart';

class GroupDeleteAlert extends StatelessWidget {
  final String? docId;

  const GroupDeleteAlert({Key? key, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return AlertDialog(
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
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              FirebaseFirestore.instance
                  .collection(collectionName.groupMessage)
                  .doc(chatCtrl.pId)
                  .collection(collectionName.chat)
                  .doc(docId)
                  .delete();
              await FirebaseFirestore.instance
                  .runTransaction((transaction) async {});
              chatCtrl.listScrollController.animateTo(0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut);

              await FirebaseFirestore.instance
                  .collection(collectionName.groupMessage)
                  .doc(chatCtrl.pId)
                  .collection(collectionName.chat)
                  .orderBy("timestamp", descending: true)
                  .limit(1)
                  .get()
                  .then((value) {
                if (value.docs.isEmpty) {
                  List receiver = value.docs[0].data()["receiver"];
                  receiver.asMap().entries.forEach((element) async {
                    FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(element.value["id"])
                        .collection(collectionName.chats)
                        .where("groupId", isEqualTo: chatCtrl.pId)
                        .get()
                        .then((value) {
                      FirebaseFirestore.instance
                          .collection(collectionName.users)
                          .doc(element.value["id"]).collection(collectionName.chats).doc(value.docs[0].id)
                          .delete();
                    });
                  });
                } else {
                  List receiver = value.docs[0].data()["receiver"];
                  receiver.asMap().entries.forEach((element) async {
                    await  FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(element.value["id"])
                        .collection(collectionName.chats)
                        .where("groupId",isEqualTo: chatCtrl.pId  )
                        .get()
                        .then((contact) {
                      if (contact.docs.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(element.value["id"])
                            .collection("chats")
                            .doc(contact.docs[0].id)
                            .update({
                          "updateStamp":
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          "lastMessage": value.docs[0].data()["content"],
                          "senderId": chatCtrl.user["id"],
                          "sender": chatCtrl.user
                        });
                      }
                    });
                  });
                }
              });
              chatCtrl.selectedIndexId = [];
              chatCtrl.showPopUp =false;
              chatCtrl.enableReactionPopup =false;
              chatCtrl.update();
            },
            child: const Text('Yes'),
          ),
        ],
      );
    });
  }
}
