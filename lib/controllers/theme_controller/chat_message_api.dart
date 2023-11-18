import 'dart:math';
import 'dart:developer' as log;
import '../../../config.dart';

class ChatMessageApi {
  //save message in user
  saveMessageInUserCollection(id, receiverId, newChatId, content, senderId,
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
    List receiver = pData["users"];
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
                    dataTitle: pData["name"]);
              }
            });
          }
        }
      });
    });
  }

  //audio and video call api
  audioAndVideoCallApi({toData, isVideoCall}) async {
    try {
      dynamic agoraToken = appCtrl.storage.read(session.agoraToken);
      log.log("agoraToken : $agoraToken");
      var userData = appCtrl.storage.read(session.user);
      String channelId = Random().nextInt(1000).toString();
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      Call call = Call(
          timestamp: timestamp,
          callerId: userData["id"],
          callerName: userData["name"],
          callerPic: userData["image"],
          receiverId: toData["id"],
          receiverName: toData["name"],
          receiverPic: toData["image"],
          callerToken: userData["pushToken"],
          receiverToken: toData["pushToken"],
          channelId: channelId,
          isVideoCall: isVideoCall,receiver: null);
   //   ClientRoleType role = ClientRoleType.clientRoleBroadcaster;
      await FirebaseFirestore.instance
          .collection(collectionName.calls)
          .doc(call.callerId)
          .collection(collectionName.calling)
          .add({
        "timestamp": timestamp,
        "callerId": userData["id"],
        "callerName": userData["name"],
        "callerPic": userData["image"],
        "receiverId": toData["id"],
        "receiverName": toData["name"],
        "receiverPic": toData["image"],
        "callerToken": userData["pushToken"],
        "receiverToken": toData["pushToken"],
        "hasDialled": true,
        "channelId": channelId,
        "isVideoCall": isVideoCall,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(collectionName.calls)
            .doc(call.receiverId)
            .collection(collectionName.calling)
            .add({
          "timestamp": timestamp,
          "callerId": userData["id"],
          "callerName": userData["name"],
          "callerPic": userData["image"],
          "receiverId": toData["id"],
          "receiverName": toData["name"],
          "receiverPic": toData["image"],
          "callerToken": userData["pushToken"],
          "receiverToken": toData["pushToken"],
          "hasDialled": false,
          "channelId": channelId,
          "isVideoCall": isVideoCall
        }).then((value)async {
          call.hasDialled = true;
          if (isVideoCall == false) {
            firebaseCtrl.sendNotification(
                title: "Incoming Audio Call...",
                msg: "${call.callerName} audio call",
                token: call.receiverToken,
                pName: call.callerName,
                image: userData["image"],
                dataTitle: call.callerName);
            var data = {
              "channelName": call.channelId,
              "call": call,
              "role": "role"
            };
            Get.toNamed(routeName.audioCall, arguments: data);
          } else {
            firebaseCtrl.sendNotification(
                title: "Incoming Video Call...",
                msg: "${call.callerName} video call",
                token: call.receiverToken,
                pName: call.callerName,
                image: userData["image"],
                dataTitle: call.callerName);

            var data = {
              "channelName": call.channelId,
              "call": call,
              "role": "role"
            };

            Get.toNamed(routeName.videoCall, arguments: data);


          }
        });
      });
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      log.log("Failed with error '${e.code}': ${e.message}");
    }
  }
}
