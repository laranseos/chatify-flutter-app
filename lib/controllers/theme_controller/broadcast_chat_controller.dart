import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatify_web/models/firebase_contact_model.dart';

import 'package:drishya_picker/drishya_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dartx/dartx_io.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../config.dart';
import 'package:universal_html/html.dart' as html;

class BroadcastChatController extends GetxController {
  String? pId,
      id,
      chatId,
      pName,
      groupId,
      imageUrl,
      peerNo,
      status,
      statusLastSeen,
      videoUrl,
      blockBy;
  dynamic  userData, broadData;
  List message =[];
  List<DrishyaEntity>? entities;
  CameraController? cameraController;
  Future<void>? initializeControllerFuture;
  Uint8List webImage = Uint8List(8);
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  List pData = [];
  List selectedIndexId = [];
  List newpData = [], userList = [], searchUserList = [];
  bool positionStreamStarted = false;
  bool isUserAvailable = true,isCamera = false;
  bool isTextBox = false, isThere = false;
  XFile? imageFile;
  XFile? videoFile;
  File? image;
  int totalUser = 0;
  String nameList = "";
  dynamic data;
  Offset tapPosition = Offset.zero;
  File? video;
  bool? isLoading = true;
  bool typing = false, isBlock = false;
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textNameController = TextEditingController();
  TextEditingController textSearchController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  late encrypt.Encrypter cryptor;
  final iv = encrypt.IV.fromLength(8);

  @override
  void onReady() {
    // TODO: implement onReady
    groupId = '';
    isLoading = false;
    imageUrl = '';
    userData = appCtrl.storage.read(session.user);

    broadData = data["data"];
    update();
    pId = data["broadcastId"];
    pData = broadData["receiverId"];
    log("pData:${pData.length}");
    totalUser = pData.length;
    nameList = "";
    for (var i = 0; i < pData.length; i++) {
      if (nameList != "") {
        nameList = "$nameList, ${pData[i]["name"]}";
      } else {
        nameList = pData[i]["name"];
      }
    }
    update();
  log("broadData : $nameList}");
    getBroadcastData();

    super.onReady();
  }


  //get broad cast data
  getBroadcastData() async {
    await FirebaseFirestore.instance
        .collection(collectionName.broadcast)
        .doc(pId)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data().toString().contains('backgroundImage')) {
          broadData["backgroundImage"] = value.data()!["backgroundImage"] ?? "";
        } else {
          broadData["backgroundImage"] = "";
        }
      } else {
        broadData["backgroundImage"] = "";
      }
      broadData["users"] = value.data()!["users"] ?? [];
    });
    log("broadData 1: $broadData");
    update();
  }

  //update typing status
  setTyping() async {
    firebaseCtrl.setIsActive();
  }

  //share document
  documentShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      isLoading = true;
      update();
      File file = File(result.files.single.path.toString());
      String fileName =
          "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";

      imageUrl = await pickerCtrl.uploadImage(file, fileNameText: fileName);
      onSendMessage(
          "${result.files.single.name}-BREAK-$imageUrl",
          result.files.single.path.toString().contains(".mp4")
              ? MessageType.video
              : result.files.single.path.toString().contains(".mp3")
                  ? MessageType.audio
                  : MessageType.doc);
    }
  }

  //location share
  locationShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();

    await permissionHandelCtrl.getCurrentPosition().then((value) async {
      var locationString =
          'https://www.google.com/maps/search/?api=1&query=${value!.latitude},${value.longitude}';
      onSendMessage(locationString, MessageType.location);
      return null;
    });
  }

  //share media
  shareMedia(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: appCtrl.appTheme.transparentColor,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.r25))),
        builder: (BuildContext context) {
          // return your layout

          //return const BroadcastFileRowList();
          return Container();
        });
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile() async {
    imageFile = pickerCtrl.imageFile;
    update();

    var image = await imageFile!.readAsBytes();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    webImage = image;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(webImage);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        log("chat_con : ${imageFile!.name}");
        String type = imageFile!.name;
        log("chat_con : ${imageFile!}");
        imageUrl = downloadUrl;
        imageFile = null;
        isLoading = false;
        log("imageUrl : $imageUrl");
        onSendMessage(imageUrl!,type.contains(".mp4") ? MessageType.video : MessageType.image);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }


// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadMultipleFile(File imageFile,MessageType messageType) async {
    imageFile = imageFile;
    update();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File( imageFile.path);
    UploadTask uploadTask = reference.putFile(file);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) async {
        imageUrl = downloadUrl;
        isLoading = false;
        onSendMessage(imageUrl!, messageType);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

  //send video after recording or pick from media
  videoSend() async {
    videoFile = pickerCtrl.videoFile;
    update();
    const Duration(seconds: 2);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(videoFile!.path);
    UploadTask uploadTask = reference.putFile(file);

    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        videoUrl = downloadUrl;
        isLoading = false;
        onSendMessage(videoUrl!, MessageType.video);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

  getImageFromCamera(context) async {
    final perm = await html.window.navigator.permissions!.query({"name": "camera"});
    await availableCameras().onError((error, stackTrace) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),backgroundColor: appCtrl.appTheme.redColor,));
      return [];
    }).then((value) {
      if(value.isNotEmpty) {
        log("value  $value");
        if (perm.state == "denied") {
          return [];
        } else {
          isCamera = true;
          cameras = value;
          update();
          cameraController = CameraController(
            // Get a specific camera from the list of available cameras.
            cameras[0],
            // Define the resolution to use.
            ResolutionPreset.medium,
          );

          // Next, initialize the controller. This returns a Future.
          initializeControllerFuture = cameraController!.initialize();
          update();
          return value;
        }
      }
    });
  }

  //pick up contact and share
  saveContactInChat(value) async {
    if (value != null) {

      FirebaseContactModel contact = value;

      String? photo;
      isLoading = true;
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .where("phone", isEqualTo: contact.phone)
          .get().then((user) {
        if(user.docs.isNotEmpty){
          photo = user.docs[0].data()["image"] ?? "";
        }
      });
      onSendMessage(
          '${contact.name}-BREAK-${contact.phone}-BREAK-$photo',
          MessageType.contact);

    }
    update();
  }

  //audio recording
  void audioRecording(BuildContext context, String type, int index) {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      backgroundColor: appCtrl.appTheme.transparentColor,
      builder: (BuildContext bc) {
        return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: appCtrl.appTheme.whiteColor,
                borderRadius: BorderRadius.circular(10)),
            child: AudioRecordingPlugin(type: type, index: index));
      },
    );
  }

  // SEND MESSAGE CLICK
  void onSendMessage(String content, MessageType type) async {
    log("pData : ${pData.length}");
    if (content.trim() != '') {
      final key = encrypt.Key.fromUtf8('my 32 length key................');
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypter.encrypt(content, iv: iv).base64;

      textEditingController.clear();
      await saveMessageInLoop(encrypted, type);
      await Future.delayed(Durations.s4);
      log("newpData : $newpData");

      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userData["id"])
          .collection(collectionName.chats)
          .where("broadcastId", isEqualTo: pId)
          .get()
          .then((snap) {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .collection(collectionName.chats)
            .doc(snap.docs[0].id)
            .update({
          "receiverId": newpData,
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": encrypted
        });
      });

      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userData["id"])
          .collection(collectionName.broadcastMessage)
          .doc(pId)
          .collection(collectionName.chat)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'sender': userData["id"],
        'senderName': userData["name"],
        'receiver': newpData,
        'content': encrypted,
        "broadcastId": pId,
        'type': type.name,
        'messageType': "sender",
        "status": "",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .collection(collectionName.chats)
            .where("broadcastId", isEqualTo: pId)
            .get();
      });

      Get.forceAppUpdate();
    }
  }

  saveMessageInLoop(String content, MessageType type) async {
    pData.asMap().entries.forEach((element) async {
      log("cha : ${element.value["chatId"]}");
      if (element.value["chatId"] != null) {
        newpData.add(element.value);
        update();
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(element.value["id"])
            .collection(collectionName.messages)
            .doc(element.value["chatId"])
            .collection(collectionName.chat)
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          'sender': userData["id"],
          'receiver': element.value["id"],
          'content': content,
          "chatId": element.value["chatId"],
          'type': type.name,
          'messageType': "sender",
          "isBlock": false,
          "isSeen": false,
          "isBroadcast": true,
          "blockBy": "",
          "blockUserId": "",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        }).then((value) async {
          await ChatMessageApi().saveMessageInUserCollection(
              element.value["id"],
              element.value["id"],
              element.value["chatId"],
              content,
              isBroadcast: true,
              userData["id"],
              userData["name"]);
        });
      } else {
        final now = DateTime.now();
        String? newChatId = now.microsecondsSinceEpoch.toString();
        update();
        element.value["chatId"] = newChatId;
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(element.value["id"])
            .collection(collectionName.messages)
            .doc(element.value["chatId"])
            .collection(collectionName.chat)
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          'sender': userData["id"],
          'receiver': element.value["id"],
          'content': content,
          "chatId": element.value["chatId"],
          'type': type.name,
          'messageType': "sender",
          "isBlock": false,
          "isSeen": false,
          "isBroadcast": true,
          "blockBy": "",
          "blockUserId": "",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        }).then((value) async {
          newpData.add(element.value);
          update();
          await ChatMessageApi().saveMessageInUserCollection(
              element.value["id"],
              element.value["id"],
              element.value["chatId"],
              content,
              isBroadcast: true,
              userData["id"],
              userData["name"]);
        });
      }
    });
    log("loop : $newpData");
  }

  //delete chat layout
  Widget buildPopupDialog(
      BuildContext context, DocumentSnapshot documentReference) {
    /*return BroadCastDeleteAlert(
      documentReference: documentReference,
    );*/
    return Container();
  }

  Widget timeLayout(document) {
    List newMessageList = document["message"];
    return Column(
      children: [
        Text(
            document["title"].contains("-other")
                ? document["title"].split("-other")[0]
                : document["title"],
            style:
            AppCss.poppinsMedium14.textColor(appCtrl.appTheme.txtColor))
            .marginSymmetric(vertical: Insets.i5),
        ...newMessageList.reversed.toList().asMap().entries.map((e) {
          return buildItem(e.key, e.value);
        }).toList()
      ],
    );
  }

// BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
  Widget buildItem(int index, document) {
    if (document['sender'] == userData["id"]) {
      return BroadcastSenderMessage(
        document: document,
        index: index,
      );
    } else {
      // RECEIVER MESSAGE
      return Container();
    }
  }

  // ON BACK PRESS
  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection(
            'users') // Your collection name will be whatever you have given in firestore database
        .doc(userData["id"])
        .update({'status': "Online"});
    Get.back();
    return Future.value(false);
  }

  //ON LONG PRESS
  onLongPressFunction(docId) {
    if (!selectedIndexId.contains(docId)) {
      selectedIndexId.add(docId);
      update();
    }
    update();
  }

  deleteBroadCast() async {
    await FirebaseFirestore.instance
        .collection(collectionName.broadcastMessage)
        .doc(pId)
        .delete()
        .then((value) async {
      await FirebaseFirestore.instance
          .collection(collectionName.broadcast)
          .doc(pId)
          .delete()
          .then((value) {
        Get.back();
        Get.back();
      });
    });
  }

  //check contact in firebase and if not exists
  saveContact(userData, {message}) async {


    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userData["id"])
        .collection("chats")
        .where("isOneToOne", isEqualTo: true)
        .get()
        .then((value) {
      bool isEmpty = value.docs
          .where((element) =>
              element.data()["senderId"] == userData["uid"] ||
              element.data()["receiverId"] == userData["uid"])
          .isNotEmpty;
      if (!isEmpty) {
        var data = {"chatId": "0", "data": userData, "message": message};

        Get.back();
        Get.toNamed(routeName.chat, arguments: data);
      } else {
        value.docs.asMap().entries.forEach((element) {
          if (element.value.data()["senderId"] == userData["uid"] ||
              element.value.data()["receiverId"] == userData["uid"]) {
            var data = {
              "chatId": element.value.data()["chatId"],
              "data": userData,
              "message": message
            };
            Get.back();

            Get.toNamed(routeName.chat, arguments: data);
          }
        });
      }
    });
  }

  getTapPosition(TapDownDetails tapDownDetails) {
    RenderBox renderBox = Get.context!.findRenderObject() as RenderBox;
    update();
    tapPosition = renderBox.globalToLocal(tapDownDetails.globalPosition);
  }

  showContextMenu(context, value, snapshot) async {
    RenderObject? overlay = Overlay.of(context).context.findRenderObject();
    final result = await showMenu(
        color: appCtrl.appTheme.whiteColor,
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: [
          _buildPopupMenuItem("Chat $pName", 0),
          _buildPopupMenuItem("Remove $pName", 1),
        ]);
    if (result == 0) {
      var data = {
        "uid": value["id"],
        "username": value["name"],
        "phoneNumber": value["phone"],
        "image": snapshot.data!.data()!["image"],
        "description": snapshot.data!.data()!["statusDesc"],
        "isRegister": true,
      };
      UserContactModel userContactModel = UserContactModel.fromJson(data);
      saveContact(userContactModel);
    }else{
      removeUserFromGroup(value, snapshot);
    }
  }


  removeUserFromGroup(value, snapshot) async {
    await FirebaseFirestore.instance
        .collection(collectionName.broadcast)
        .doc(pId)
        .get()
        .then((group) {
      if (group.exists) {
        List user = group.data()!["users"];
        user.removeWhere((element) => element["phone"] == value["phone"]);
        update();
        FirebaseFirestore.instance
            .collection(collectionName.broadcast)
            .doc(pId)
            .update({"users": user}).then((value) {
          getBroadcastData();
        });
      }
    });
  }

  PopupMenuItem _buildPopupMenuItem(String title, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(children: [
        Text(title,
            style:
            AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor))
      ]),
    );
  }
}
