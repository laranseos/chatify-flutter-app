import 'package:chatify_web/config.dart';

class GroupMessageApi {
  getMessageAsPerDate(snapshot) {
    final chatCtrl = Get.isRegistered<GroupChatMessageController>()
        ? Get.find<GroupChatMessageController>()
        : Get.put(GroupChatMessageController());
    List<QueryDocumentSnapshot<Object?>> message = (snapshot.data!).docs;
    message.asMap().entries.forEach((element) {
      if (getDate(element.value.id) == "today") {
        List<QueryDocumentSnapshot<Object?>> newMessageList = [];
        bool isExist = chatCtrl.message
            .where((element) => element["title"] == "today")
            .isNotEmpty;

        if (isExist) {
          if (!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            int index = chatCtrl.message
                .indexWhere((element) => element["title"] == "today");
            chatCtrl.message[index]["message"] = newMessageList;
          }
        } else {
          if (!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            var data = {
              "title": getDate(element.value.id),
              "message": newMessageList
            };

            chatCtrl.message = [data];
          }
        }
      }
      if (getDate(element.value.id) == "yesterday") {
        List<QueryDocumentSnapshot<Object?>> newMessageList = [];
        bool isExist = chatCtrl.message
            .where((element) => element["title"] == "yesterday")
            .isNotEmpty;

        if (isExist) {
          if (!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            int index = chatCtrl.message
                .indexWhere((element) => element["title"] == "yesterday");
            chatCtrl.message[index]["message"] = newMessageList;
          }
        } else {
          if (!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            var data = {
              "title": getDate(element.value.id),
              "message": newMessageList
            };

            if (chatCtrl.message.isNotEmpty) {
              chatCtrl.message.add(data);
            } else {
              chatCtrl.message = [data];
            }
          }
        }
      }
      if (getDate(element.value.id) != "yesterday" &&
          getDate(element.value.id) != "today") {
        List<QueryDocumentSnapshot<Object?>> newMessageList = [];
        bool isExist = chatCtrl.message
            .where((element) => element["title"].contains("-other"))
            .isNotEmpty;

        if (isExist) {
          if (!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            int index = chatCtrl.message
                .indexWhere((element) => element["title"].contains("-other"));
            chatCtrl.message[index]["message"] = newMessageList;
          }
        } else {
          if (!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            var data = {
              "title": getWhen(element.value.id),
              "message": newMessageList
            };

            if (chatCtrl.message.isNotEmpty) {
              chatCtrl.message.add(data);
            } else {
              chatCtrl.message = [data];
            }
          }
        }
      }
    });
  }

  saveGroupMessage(encrypted,MessageType type)async{
    final chatCtrl = Get.isRegistered<GroupChatMessageController>()
        ? Get.find<GroupChatMessageController>()
        : Get.put(GroupChatMessageController());
    List  userList = chatCtrl.pData["groupData"]["users"];
    userList.asMap().entries.forEach((element)async {
      await   FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(element.value["id"])
          .collection(collectionName.groupMessage)
          .doc(chatCtrl.pId)
          .collection(collectionName.chat)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'sender': appCtrl.user["id"],
        'senderName': appCtrl.user["name"],
        'receiver': chatCtrl.pData["groupData"]["users"],
        'content': encrypted,
        "groupId": chatCtrl.pId,
        'type': type.name,
        'messageType': "sender",
        "status": "",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });

  }
}
