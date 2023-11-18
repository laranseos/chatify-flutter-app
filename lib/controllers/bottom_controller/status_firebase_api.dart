import 'dart:developer';

import '../../../../config.dart';

class StatusFirebaseApi {
  //add status
  addStatus(imageUrl, statusType, {statusText, statusBgColor}) async {
    var user = appCtrl.storage.read(session.user);
    List<PhotoUrl> statusImageUrls = [];
    log("userISS :${user["id"]}");
    await  FirebaseFirestore.instance
        .collection(collectionName.users).doc(user["id"]).collection(collectionName.status)
        .get().then((statusesSnapshot) async {
      log("statusesSnapshot.docs.isNotEmpty :${statusesSnapshot.docs}");
      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromJson(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl!;
        var data = {
          "image": statusType == StatusType.text.name ? "" : imageUrl!,
          "timestamp": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          "isExpired": false,
          "statusType": statusType,
          "statusText": statusText,
          "statusBgColor": statusBgColor,
        };

        statusImageUrls.add(PhotoUrl.fromJson(data));
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(user["id"])
            .collection(collectionName.status)
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls.map((e) => e.toJson()).toList(),
          "updateAt": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()
        }).then((value) {
          final statusCtrl = Get.find<StatusController>();
          statusCtrl.isLoading = false;
          statusCtrl.update();
        });
        return;
      } else {
        var data = {
          "image": statusType == StatusType.text.name ? "" : imageUrl!,
          "timestamp": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          "isExpired": false,
          "statusType": statusType,
          "statusText": statusText,
          "statusBgColor": statusBgColor,
        };
        statusImageUrls = [PhotoUrl.fromJson(data)];
      }

      Status status = Status(
          username: user["name"],
          phoneNumber: user["phone"],
          photoUrl: statusImageUrls,
          createdAt: DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          updateAt: DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          profilePic: user["image"],
          uid: user["id"],
          isSeenByOwn: false);

      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.status)
          .add(status.toJson())
          .then((value) {
        final statusCtrl = Get.find<StatusController>();
        statusCtrl.isLoading = false;
        statusCtrl.update();
      });
    });
  }

  //get status list
  List<Status> getStatusUserList(List<Contact> contacts,
      QuerySnapshot<Map<String, dynamic>> statusesSnapshot) {
    var user = appCtrl.storage.read(session.user);
    List<Status> statusData = [];
    statusesSnapshot.docs
        .asMap()
        .entries
        .forEach((element) {
      int i = contacts.indexWhere((contactList) {
        if (contactList.phones.isNotEmpty) {
          return (contactList.phones.isNotEmpty);
        } else {
          return false;
        }
      });
      debugPrint("i :$i");
      if (i > 0) {
        if (element.value.data()["uid"] != user["id"]) {
          Status tempStatus = Status.fromJson(element.value.data());
          if (!statusData.contains(tempStatus)) {
            statusData.add(tempStatus);
          }
        }
      }
    });

    appCtrl.storage.write(session.statusList, statusData);
    log("statusData : $statusData");

    return statusData;
  }
}
