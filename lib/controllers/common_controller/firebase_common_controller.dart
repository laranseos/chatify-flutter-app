import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:chatify_web/config.dart';

class FirebaseCommonController extends GetxController {
  List<PhotoUrl> newPhotoList = [];

  //online status update
  void setIsActive() async {
    var user = appCtrl.storage.read(session.user) ?? "";
    if (user != "") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .update(
        {
          "status": "Online",
          "isSeen": true,
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()
        },
      );
    }
  }

  //last seen update
  void setLastSeen() async {
    var user = appCtrl.storage.read(session.user) ?? "";
    if (user != "") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .update(
        {
          "status": "Offline",
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()
        },
      );
    }
  }

  //last seen update
  void groupTypingStatus(pId, documentId, isTyping) async {
    var user = appCtrl.storage.read(session.user);
    await FirebaseFirestore.instance.collection("groups").doc(pId).update(
      {"status": isTyping ? "${user["name"]} is typing" : ""},
    );
  }

  //typing update
  void setTyping() async {
    var user = appCtrl.storage.read(session.user);
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .update(
      {
        "status": "typing...",
        "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }

  //status delete after 24 hours
  statusDeleteAfter24Hours() async {
    if (appCtrl.user != "") {
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.status)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          Status status = Status.fromJson(value.docs[0].data());
          await getPhotoUrl(status.photoUrl!).then((list) async {
            List<PhotoUrl> photoUrl = list;
            log("photoUrl : ${photoUrl.length}");
            log("photoUrl : ${status.photoUrl!.length}");
            if (photoUrl.isEmpty) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.status)
                  .doc(value.docs[0].id)
                  .delete();
            } else {
              if (status.photoUrl!.length < photoUrl.length) {
                var statusesSnapshot = await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(appCtrl.user["id"])
                    .collection(collectionName.status)
                    .get();
                await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(appCtrl.user["id"])
                    .collection(collectionName.status)
                    .doc(statusesSnapshot.docs[0].id)
                    .update(
                        {'photoUrl': photoUrl.map((e) => e.toJson()).toList()});
              }
            }
          });
        }
      });
    }
  }

  Future<List<PhotoUrl>> getPhotoUrl(List<PhotoUrl> photoUrl) async {
    for (int i = 0; i < photoUrl.length; i++) {
      var millis = int.parse(photoUrl[i].timestamp.toString());
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(millis);
      var date = DateTime.now();
      Duration diff = date.difference(dt);

      if (diff.inHours <= 24) {
        newPhotoList.add(photoUrl[i]);
      }
      update();
    }
    log("newPhotoList : ${newPhotoList.length}");
    update();
    return newPhotoList;
  }

  //delete all contacts
  deleteAllContacts() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .update({"isWebLogin": false});
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.userContact)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.asMap().entries.forEach((element) {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(appCtrl.user["id"])
              .collection(collectionName.userContact)
              .doc(element.value.id)
              .delete();
        });
      }
    });
  }

  deleteAllListContact() async {
    await Future.delayed(Durations.s4);
    if (appCtrl.contactList.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .update({"isWebLogin": false});
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.userContact)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          if (value.docs.length != 1) {
            List userList =
                value.docs.getRange(0, value.docs.length - 1).toList();
            userList.asMap().entries.forEach((element) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.userContact)
                  .doc(element.value.id)
                  .delete();
            });
          }
        }
      });
    }
  }

  //send notification
  Future<void> sendNotification(
      {title,
      msg,
      token,
      image,
      dataTitle,
      chatId,
      groupId,
      userContactModel,
      pId,
      pName}) async {
    log('token : $token');

    final data = {
      "notification": {
        "body": msg,
        "title": dataTitle,
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "alertMessage": 'true',
        "title": title,
        "chatId": chatId,
        "groupId": groupId,
        "userContactModel": userContactModel,
        "pId": pId,
        "pName": pName,
        "imageUrl": image,
        "isGroup": false
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=${appCtrl.userAppSettingsVal!.firebaseServerToken}'
    };

    BaseOptions options = BaseOptions(
      connectTimeout: Durations.s5,
      receiveTimeout: Durations.s3,
      headers: headers,
    );

    try {
      final response = await Dio(options)
          .post('https://fcm.googleapis.com/fcm/send', data: data);

      if (response.statusCode == 200) {
        log('Alert push notification send');
      } else {
        log('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      log('exception $e');
    }
  }
}
