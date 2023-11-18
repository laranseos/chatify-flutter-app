import 'dart:async';
import 'dart:developer' as log;
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatify_web/models/firebase_contact_model.dart';
import 'package:chatify_web/screens/dashboard_pages/group_chat_message/group_message_api.dart';

import 'package:dartx/dartx_io.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../config.dart';
import 'package:universal_html/html.dart' as html;

class GroupChatMessageController extends GetxController {
  String? pId,
      id,
      documentId,
      pName,
      groupImage,
      groupId,
      imageUrl,
      status,
      statusLastSeen,
      nameList,
      videoUrl,
      backgroundImage;
  dynamic pData, allData;
  List message = [];
  bool positionStreamStarted = false,isUserProfile= false;
  int pageSize = 20;CameraController? cameraController;
  Future<void>? initializeControllerFuture;
  XFile? imageFile, videoFile;
  List userList = [],
      searchUserList = [],
      selectedIndexId = [],
      searchChatId = [];
  List<DrishyaEntity>? entities;
  File? image;
  Uint8List webImage = Uint8List(8);
int isSelectedHover=0;
  bool isLoading = true,
      isTextBox = false,
      isHover = false,
      isDescTextBox = false,
      isThere = true,
      typing = false,
      isChatSearch = false;
  dynamic user;
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textNameController = TextEditingController();
  TextEditingController textDescController = TextEditingController();
  TextEditingController textSearchController = TextEditingController();
  TextEditingController txtChatSearch = TextEditingController();
  ScrollController listScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  bool enableReactionPopup = false;
  bool showPopUp = false;
  int? count;
  List clearChatId = [];
  dynamic data;
  late encrypt.Encrypter cryptor;
  bool isCamera = false;
  Offset tapPosition = Offset.zero;
  final iv = encrypt.IV.fromLength(8);
  final PagingController pagingController = PagingController(firstPageKey: 0);

  @override
  void onReady() {
    // TODO: implement onReady
    user = appCtrl.storage.read(session.user);
    id = user["id"];
    groupId = '';
    isLoading = false;


    imageUrl = '';
    // data = Get.arguments;
    log.log("SET : $data");
    if (data != null) {
      pData = data;
      pId = pData["message"]["groupId"];
      pName = pData["groupData"]["name"];
      groupImage = pData["groupData"]["image"];
      log.log("SENDER : ${pData["message"]["senderId"]}");
      update();
    }
    getPeerStatus();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    update();

    super.onReady();
  }

  //fetch data
  Future<void> fetchPage(pageKey) async {
    pagingController.itemList = [];

    try {
      final newItems = message;
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
    isLoading = false;
    update();
  }

//get group data
  getPeerStatus() async {
    nameList = "";
    nameList = null;
    log.log("receiver");
    FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(pId)
        .get()
        .then((value) async {
      log.log("value.exists :${value.exists}");
      if (value.exists) {
        allData = value.data();
        update();
        backgroundImage = value.data()!['backgroundImage'] ?? "";
        List receiver = pData["groupData"]["users"] ?? [];
        log.log("receiver : $receiver");
        log.log("allDATA : $allData");
        clearChatId = value.data()!["clearChatId"] ?? [];
        nameList = (receiver.length - 1).toString();
        if (pData["message"]["senderId"] != user["id"]) {
          await FirebaseFirestore.instance
              .collection(collectionName.groupMessage)
              .doc(pId)
              .collection(collectionName.chat)
              .get()
              .then((value) {
            value.docs.asMap().entries.forEach((element) {
              if (element.value.exists) {
                if (element.value.data()["sender"] != user["id"]) {
                  List seenMessageList =
                      element.value.data()["seenMessageList"] ?? [];
                  log.log("seenMessageList : $seenMessageList");
                  bool isAvailable = seenMessageList
                      .where((element) => element["userId"] == user["id"])
                      .isNotEmpty;
                  if (!isAvailable) {
                    var data = {
                      "userId": user["id"],
                      "date": DateTime.now().millisecondsSinceEpoch
                    };

                    seenMessageList.add(data);
                  }
                  FirebaseFirestore.instance
                      .collection(collectionName.groupMessage)
                      .doc(pId)
                      .collection(collectionName.chat)
                      .doc(element.value.id)
                      .update({"seenMessageList": seenMessageList});

                  FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(user["id"])
                      .collection(collectionName.chats)
                      .where("groupId", isEqualTo: pId)
                      .limit(1)
                      .get()
                      .then((userChat) {
                    if (userChat.docs.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection(collectionName.users)
                          .doc(user["id"])
                          .collection(collectionName.chats)
                          .doc(userChat.docs[0].id)
                          .update({"seenMessageList": seenMessageList});
                    }
                  });
                }
              }
            });
          });
        }
      }

      update();
    });
    user = appCtrl.storage.read(session.user);
    if (backgroundImage != null || backgroundImage != "") {
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .get()
          .then((value) {
        if (value.exists) {
          backgroundImage = value.data()!["backgroundImage"] ?? "";
        }
        update();
      });
    }

    FirebaseFirestore.instance
        .collection(collectionName.groupMessage)
        .doc(pId)
        .collection(collectionName.chat)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        documentId = value.docs[0].id;
      }
    });

    return status;
  }

  //document share
  documentShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      isLoading = true;
      update();
      /*File file = File(result.files.single.path.toString());*/
      webImage = result.files.single.bytes!;

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putData(webImage);
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((downloadUrl) {
          imageUrl = downloadUrl;
          isLoading = false;
          onSendMessage(
              "${result.files.single.name}-BREAK-$imageUrl",
              result.names.single.toString().contains(".mp4")
                  ? MessageType.video
                  : result.names.single.toString().contains(".mp3")
                      ? MessageType.audio
                      : MessageType.doc);
          update();
        }, onError: (err) {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: 'Not Upload');
        });
      });
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

  getCamera() async {}

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile({isGroupImage = false, groupImageFile}) async {


    imageFile = pickerCtrl.imageFile;
    update();

    var image = await imageFile!.readAsBytes();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    webImage = image;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(webImage);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl)async {

        String type = imageFile!.name;

        imageUrl = downloadUrl;
        imageFile = null;
        isLoading = false;
        if (isGroupImage) {
          await FirebaseFirestore.instance
              .collection(collectionName.groups)
              .doc(pId)
              .update({'image': imageUrl}).then((value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user["id"])
                .get()
                .then((snap) async {
              groupImage = imageUrl;
              update();
            });
          });
        } else {
          onSendMessage(imageUrl!,
              type.contains(".mp4") ? MessageType.video : MessageType.image);
        }
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

  uploadCameraImage()async{
    var image = await imageFile!.readAsBytes();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    webImage = image;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(webImage);

    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) async {
        imageUrl = downloadUrl;
        isLoading = false;
        onSendMessage(imageUrl!, MessageType.image);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
    cameraController!.dispose();
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadMultipleFile(File imageFile, MessageType messageType) async {
    imageFile = imageFile;
    update();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(imageFile.path);
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

  Future videoSend() async {
    videoFile = pickerCtrl.videoFile;
    update();
    if (videoFile != null) {
      const Duration(seconds: 2);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      var file = File(videoFile!.path);
      UploadTask uploadTask = reference.putFile(file);
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((downloadUrl) {
          videoUrl = downloadUrl;
          isLoading = false;

          pickerCtrl.videoFile = null;

          pickerCtrl.video = null;
          update();
          pickerCtrl.update();
          onSendMessage(videoUrl!, MessageType.video);
          update();
        }, onError: (err) {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: 'Image is Not Valid');
        });
      }).then((value) {
        videoFile = null;
        pickerCtrl.videoFile = null;

        pickerCtrl.video = null;
        videoUrl = "";
        update();
        pickerCtrl.update();
      });
    }
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
    ).then((value) async {
      File file = File(value);

      String fileName =
          "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();

      onSendMessage(downloadUrl, MessageType.audio);
    });
  }

  // SEND MESSAGE CLICK
  void onSendMessage(String content, MessageType type, {groupId}) async {
    isLoading = true;
    textEditingController.clear();
    update();
    final key = encrypt.Key.fromUtf8('my 32 length key................');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(content, iv: iv).base64;

    if (content.trim() != '') {
      var user = appCtrl.storage.read(session.user);
      id = user["id"];
      await  GroupMessageApi().saveGroupMessage(encrypted, type);
      await ChatMessageApi().saveGroupData(id, pId, encrypted, pData);
      isLoading = false;
      videoFile = null;
      videoUrl = "";
      pickerCtrl.videoFile = null;

      pickerCtrl.video = null;
      update();
      pickerCtrl.update();
      update();
      listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  //delete chat layout
  buildPopupDialog(docId) async {
    await showDialog(
        context: Get.context!,
        builder: (_) => GroupDeleteAlert(docId: docId,));
  }

  Widget timeLayout(document) {
    List newMessageList = document["message"];
    return Column(
      children: [
        Text(document["title"].contains("-other") ? document["title"].split("-other")[0]: document["title"],style: AppCss.poppinsMedium14.textColor(appCtrl.appTheme.txtColor)).marginSymmetric(vertical: Insets.i5),
        ...newMessageList.reversed.toList().asMap().entries.map((e) {
          return buildItem(e.key, e.value, e.value.id);
        }).toList()
      ],
    );
  }


// BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
  Widget buildItem(int index, DocumentSnapshot document, docId) {
    log.log("CHECK NOTE : ${document["type"] == MessageType.note.name}");
    return Column(children: [
       (document['sender'] == user["id"])
          ? GroupSenderMessage(
          document: document,
          docId: docId,
          index: index,
          currentUserId: user["id"])
          .inkWell(onTap: () {
        enableReactionPopup = false;
        showPopUp = false;
        selectedIndexId = [];
        update();
      })
          : document['sender'] != user["id"]
          ?
      // RECEIVER MESSAGE
      GroupReceiverMessage(
        document: document,
        index: index,
        docId: docId,
      ).inkWell(onTap: () {
        enableReactionPopup = false;
        showPopUp = false;
        selectedIndexId = [];
        update();
      })
          : Container()
    ]);
  }


  // ON BACK PRESS
  Future<bool> onBackPress() {
    firebaseCtrl.groupTypingStatus(pId, documentId, false);
    Get.back();
    return Future.value(false);
  }

  //ON LONG PRESS
  onLongPressFunction(docId) {
    showPopUp = true;
    enableReactionPopup = true;

    if (!selectedIndexId.contains(docId)) {
      if (showPopUp == false) {
        selectedIndexId.add(docId);
      } else {
        selectedIndexId = [];
        selectedIndexId.add(docId);
      }
      update();
    }
    update();
  }

  //exit group

  //delete chat layout
  exitGroupDialog() async {
    await showDialog(
        context: Get.context!,
        builder:
            (_) => /*ExitGroupAlert(
              name: pName,
            )*/
                Container());
  }

  //delete group
  deleteGroup() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .collection(collectionName.chats)
        .where("groupId", isEqualTo: pId)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(user["id"])
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .delete()
            .then((value) {
          Get.back();
          Get.back();
        });
      }
    });
  }

// GET IMAGE FROM GALLERY
  Future getImage(source) async {
    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: source))!;
    log.log("imageFile: $imageFile");
    isLoading = true;
    update();
    if (imageFile != null) {
      update();
      uploadFile(isGroupImage: true, groupImageFile: imageFile);
    }
  }

  getImageFromCamera(context) async {
    final perm = await html.window.navigator.permissions!.query({"name": "camera"});
    await availableCameras().onError((error, stackTrace) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),backgroundColor: appCtrl.appTheme.redColor,));
      return [];
    }).then((value) {
      if(value.isNotEmpty) {

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

  //image picker option
  imagePickerOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.r25)),
        ),
        builder: (BuildContext context) {
          // return your layout
          return ImagePickerLayout(cameraTap: () {
            getImage(ImageSource.camera);
            Get.back();
          }, galleryTap: () {
            getImage(ImageSource.gallery);
            Get.back();
          });
        });
  }

  //check contact in firebase and if not exists
  saveContact(userData, {message}) async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
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
        log.log("arg : $data");
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
            log.log("arg : $data");
            Get.toNamed(routeName.chat, arguments: data);
          }
        });

        //
      }
    });
  }

  removeUserFromGroup(value, snapshot) async {
    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(pId)
        .get()
        .then((group) {
      if (group.exists) {
        List user = group.data()!["users"];
        user.removeWhere((element) => element["phone"] == value["phone"]);
        update();
        FirebaseFirestore.instance
            .collection(collectionName.groups)
            .doc(pId)
            .update({"users": user}).then((value) {
          getPeerStatus();
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
    } else {
      removeUserFromGroup(value, snapshot);
    }
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

  Widget searchTextField() {
    return TextField(
      controller: txtChatSearch,
      onChanged: (val) async {
        count = null;
        searchChatId = [];
        selectedIndexId = [];
        message.asMap().entries.forEach((e) {
          if (decryptMessage(e.value.data()["content"])
              .toLowerCase()
              .contains(val)) {
            if (!searchChatId.contains(e.key)) {
              searchChatId.add(e.key);
            } else {
              searchChatId.remove(e.key);
            }
          }
          update();
        });
      },
      autofocus: true,
      //Display the keyboard when TextField is displayed
      cursorColor: appCtrl.appTheme.blackColor,
      style: AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor),
      textInputAction: TextInputAction.search,
      //Specify the action button on the keyboard
      decoration: InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(color: appCtrl.appTheme.blackColor)),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(color: appCtrl.appTheme.blackColor)),
        hintText: 'Search', //Text that is displayed when nothing is entered.
      ),
    );
  }
}
