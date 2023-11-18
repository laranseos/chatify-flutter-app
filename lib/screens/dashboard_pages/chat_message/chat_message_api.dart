
import 'dart:developer' as log;
import '../../../config.dart';

class ChatMessageApi {
  Future saveMessage(
      newChatId, pId, encrypted, MessageType type, dateTime, senderId,
      {isBlock = false,
      isSeen = false,
      isBroadcast = false,
      blockBy = "",
      blockUserId = ""}) async {
    log.log("SAVE");
    dynamic userData = appCtrl.storage.read(session.user);
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(senderId)
        .collection(collectionName.messages)
        .doc(newChatId)
        .collection(collectionName.chat)
        .doc(dateTime)
        .set({
      'sender': userData["id"],
      'receiver': pId,
      'content': encrypted,
      "chatId": newChatId,
      'type': type.name,
      'messageType': "sender",
      "isBlock": isBlock,
      "isSeen": isSeen,
      "isBroadcast": isBroadcast,
      "blockBy": blockBy,
      "blockUserId": blockUserId,
      'timestamp': dateTime,
    }, SetOptions(merge: true));
  }

  //save message in user
  saveMessageInUserCollection(
      id, receiverId, newChatId, content, senderId, userName,
      {isBlock = false, isBroadcast = false}) async {
    final chatCtrl = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(id)
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: newChatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id)
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "chatId": newChatId,
          "isSeen": false,
          "isGroup": false,
          "name": userName,
          "isBlock": isBlock ?? false,
          "isOneToOne": true,
          "isBroadcast": isBroadcast,
          "blockBy": isBlock ? id : "",
          "blockUserId": isBlock ? receiverId : "",
          "receiverId": receiverId,
        }).then((value) {
          chatCtrl.textEditingController.text = "";
          chatCtrl.update();
        });
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id)
            .collection(collectionName.chats)
            .add({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "isSeen": false,
          "isGroup": false,
          "chatId": newChatId,
          "isBlock": isBlock ?? false,
          "isOneToOne": true,
          "name": userName,
          "isBroadcast": isBroadcast,
          "blockBy": isBlock ? id : "",
          "blockUserId": isBlock ? receiverId : "",
          "receiverId": receiverId,
        }).then((value) {
          chatCtrl.textEditingController.text = "";
          chatCtrl.update();
        });
      }
    }).then((value) {
      chatCtrl.isLoading = false;
      chatCtrl.update();
      Get.forceAppUpdate();
    });
  }

  //save group data
  saveGroupData(
    id,
    groupId,
    content,
    pData,
  ) async {
    var user = appCtrl.storage.read(session.user);
    List receiver = pData["groupData"]["users"];
    receiver.asMap().entries.forEach((element) async {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(element.value["id"])
          .collection(collectionName.chats)
          .where("groupId", isEqualTo: groupId)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(element.value["id"])
              .collection(collectionName.chats)
              .doc(value.docs[0].id)
              .update({
            "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "lastMessage": content,
            "senderId": user["id"],
            "name": pData["groupData"]["name"]
          });
          if (user["id"] != element.value["id"]) {
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(element.value["id"])
                .get()
                .then((snap) {
              if (snap.data()!["pushToken"] != "") {
                firebaseCtrl.sendNotification(
                    title: "Group Message",
                    msg: content,
                    groupId: groupId,
                    token: snap.data()!["pushToken"],
                    dataTitle: pData["groupData"]["name"]);
              }
            });
          }
        }
      });
    });
  }

  getMessageAsPerDate(snapshot) async {
    final chatCtrl = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    List<QueryDocumentSnapshot<Object?>> message = (snapshot.data!).docs;
    log.log("Snap : ${message.length}");
    List<QueryDocumentSnapshot<Object?>> newMessageList = [];
    message.asMap().entries.forEach((element) {
      if (chatCtrl.message.isNotEmpty) {
        if (getDate(element.value.id) == "today") {

          bool isExist = chatCtrl.message.where((message) {
            return message["title"] == "today";
          }).isNotEmpty;
  log.log("isExist : %$isExist");
          if (isExist) {
            if (!newMessageList.contains(element.value)) {
              newMessageList.add(element.value);
              int index = chatCtrl.message
                  .indexWhere((message) => message["title"] == "today");
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
                  .indexWhere((message) => message["title"] == "yesterday");
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
      }else{
        List<QueryDocumentSnapshot<Object?>> newMessageList = [];
        if (!newMessageList.contains(element.value)) {
          newMessageList.add(element.value);
          var data = {
            "title": getWhen(element.value.id),
            "message": newMessageList
          };

          chatCtrl.message = [data];
        }
      }
    });
    log.log("MESSAGE : ${chatCtrl.message}");

    return chatCtrl.message;
  }

  getBroadcastMessageAsPerDate(snapshot){
    final chatCtrl = Get.isRegistered<BroadcastChatController>()
        ? Get.find<BroadcastChatController>()
        : Get.put(BroadcastChatController());
    List<QueryDocumentSnapshot<Object?>> message =
        (snapshot.data!).docs;
    message.asMap().entries.forEach((element) {

      if (getDate(element.value.id) == "today") {
        List<QueryDocumentSnapshot<Object?>> newMessageList = [];
        bool isExist = chatCtrl.message
            .where((element) => element["title"] == "today")
            .isNotEmpty;

        if (isExist) {
          if(!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            int index = chatCtrl.message.indexWhere(
                    (element) =>
                element["title"] == "today");
            chatCtrl.message[index]["message"] =
                newMessageList;
          }
        } else {
          if(!newMessageList.contains(element.value)) {
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
          if(!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            int index = chatCtrl.message.indexWhere(
                    (element) =>
                element["title"] == "yesterday");
            chatCtrl.message[index]["message"] =
                newMessageList;
          }
        } else {
          if(!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            var data = {
              "title": getDate(element.value.id),
              "message": newMessageList
            };

            if(chatCtrl.message.isNotEmpty){
              chatCtrl.message.add(data);
            }else {
              chatCtrl.message = [data];
            }
          }
        }
      }
      if(getDate(element.value.id) != "yesterday" && getDate(element.value.id) != "today"){
        List<QueryDocumentSnapshot<Object?>> newMessageList = [];
        bool isExist = chatCtrl.message
            .where((element) => element["title"].contains("-other"))
            .isNotEmpty;

        if (isExist) {
          if(!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            int index = chatCtrl.message.indexWhere(
                    (element) =>
                    element["title"].contains("-other"));
            chatCtrl.message[index]["message"] =
                newMessageList;
          }
        } else {
          if(!newMessageList.contains(element.value)) {
            newMessageList.add(element.value);
            var data = {
              "title": getWhen(element.value.id),
              "message": newMessageList
            };

            if(chatCtrl.message.isNotEmpty){
              chatCtrl.message.add(data);
            }else {
              chatCtrl.message = [data];
            }
          }
        }
      }
    });

  }
}
