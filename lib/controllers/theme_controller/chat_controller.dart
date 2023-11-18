import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatify_web/models/firebase_contact_model.dart';

import 'package:dartx/dartx_io.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:drishya_picker/drishya_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

import '../../config.dart';

class ChatController extends GetxController {
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
  List message =[];
  int isSelectedHover = 0;
  dynamic pData, allData, userData;
  CameraController? cameraController;
  Uint8List webImage = Uint8List(8);
  Future<void>? initializeControllerFuture;
  List<DrishyaEntity>? entities;
  UserContactModel? userContactModel;
  bool positionStreamStarted = false;
  bool isUserAvailable = true,
      isCamera = false,
      isHover = false,
      isUserProfile = false;
  XFile? imageFile;
  XFile? videoFile;

  String? audioFile, wallPaperType;
  String selectedImage = "";
  final picker = ImagePicker();
  File? selectedFile;
  File? image;
  File? video;
  int? count;
  bool isLoading = false;
  bool enableReactionPopup = false, isChatSearch = false;
  bool showPopUp = false;
  List selectedIndexId = [];
  List clearChatId = [], searchChatId = [];

  bool typing = false, isBlock = false;
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());
  TextEditingController textEditingController = TextEditingController();
  TextEditingController txtChatSearch = TextEditingController();
  ScrollController listScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  late encrypt.Encrypter cryptor;
  dynamic data;
  final iv = encrypt.IV.fromLength(8);

  @override
  void onReady() {
    // TODO: implement onReady

    groupId = '';
    isLoading = false;
    imageUrl = '';
    userData = appCtrl.storage.read(session.user);

    log("data : $data");
    log("userData : $userData");
    if (data == "No User") {
      isUserAvailable = false;
    } else {
      userContactModel = data["data"];
      pId = userContactModel!.uid;
      pName = userContactModel!.username;
      chatId = data["chatId"];
      isUserAvailable = true;
      update();
    }
    update();
    getChatData();

    super.onReady();
  }

  //get chat data
  getChatData() async {
    if (chatId != "0") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.chats)
          .where("chatId", isEqualTo: chatId)
          .get()
          .then((value) {
        log("allData : ${value.docs[0].data()}");
        allData = value.docs[0].data();
        clearChatId = allData["clearChatId"] ?? [];
        update();
      });
    } else {
      onSendMessage(fonts.noteEncrypt.tr, MessageType.note);
    }
    seenMessage();
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(pId)
        .get()
        .then((value) {
      pData = value.data();

      update();
      log("get L : $pData");
    });
    log("allData : $allData");

    if (allData != null) {
      if (allData["backgroundImage"] != null ||
          allData["backgroundImage"] != "") {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .get()
            .then((value) {
          if (value.exists) {
            allData["backgroundImage"] = value.data()!["backgroundImage"];
          }
        });
        update();
      }
    } else {
      allData = {};
      allData["backgroundImage"] = "";
      allData["isBlock"] = false;
    }
    log("CHECK BACK : ${allData["backgroundImage"]}");
    update();

    if (data["message"] != null) {
      //PhotoUrl photoUrl = PhotoUrl.fromJson(data["message"]);
      log("ARH : ${data["message"]}");
      onSendMessage(
          data["message"].statusType == StatusType.text.name
              ? data["message"].statusText!
              : data["message"].image!,
          data["message"].statusType == StatusType.image.name
              ? MessageType.image
              : data["message"].statusType == StatusType.text.name
                  ? MessageType.text
                  : MessageType.video);
    }
  }

  //update typing status
  setTyping() async {
    textEditingController.addListener(() {
      if (textEditingController.text.isNotEmpty) {
        firebaseCtrl.setTyping();
        typing = true;
      }
      if (textEditingController.text.isEmpty && typing == true) {
        firebaseCtrl.setIsActive();
        typing = false;
      }
    });
  }

  //seen all message
  seenMessage() async {
    log("ALL : $allData");
    log("userData : $userData");
    log("c : $pId");
    if (allData != null) {
      if (allData["senderId"] != userData["id"]) {
        await FirebaseFirestore.instance
            .collection(collectionName.messages)
            .doc(chatId)
            .collection(collectionName.chat)
            .where("sender", isEqualTo: pId)
            .get()
            .then((value) {
          value.docs.asMap().entries.forEach((element) {
            FirebaseFirestore.instance
                .collection(collectionName.messages)
                .doc(chatId)
                .collection(collectionName.chat)
                .doc(element.value.id)
                .update({"isSeen": true});
          });
        });
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .collection(collectionName.chats)
            .where("chatId", isEqualTo: chatId)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(userData["id"])
                .collection(collectionName.chats)
                .doc(value.docs[0].id)
                .update({"isSeen": true});
          }
        });
      }
    }
  }

  //share document
  documentShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      isLoading = true;
      update();
      Get.forceAppUpdate();
      File file = File(result.files.single.path.toString());
      String fileName =
          "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";
      log("file : $file");
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      isLoading = true;
      update();
      log("fileName : $downloadUrl");
      onSendMessage(
          "${result.files.single.name}-BREAK-$downloadUrl",
          result.files.single.path.toString().contains(".mp4")
              ? MessageType.video
              : result.files.single.path.toString().contains(".mp3")
                  ? MessageType.audio
                  : MessageType.doc);
    }
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
    log("cameras : $cameras");
  }

  //block user
//block user
  blockUser() async {
    log("VLOCK");
    DateTime now = DateTime.now();
    String? newChatId =
    chatId == "0" ? now.microsecondsSinceEpoch.toString() : chatId;
    chatId = newChatId;
    update();
    final key = encrypt.Key.fromUtf8('my 32 length key................');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    if (allData["isBlock"] == true) {

      final encrypted =
          encrypter.encrypt("You unblock this contact", iv: iv).base64;

      ChatMessageApi().saveMessage(
          newChatId,
          pId,
          encrypted,
          MessageType.messageType,
          DateTime.now().millisecondsSinceEpoch.toString(),
          userData["id"]);

      await ChatMessageApi().saveMessageInUserCollection(
          userData["id"],
          pId,
          newChatId,
          "You unblock this contact",
          isBlock: false,
          userData["id"],
          userData["name"]);
    } else {

      final encrypted =
          encrypter.encrypt("You block this contact", iv: iv).base64;

      ChatMessageApi().saveMessage(
          newChatId,
          pId,
          encrypted,
          MessageType.messageType,
          DateTime.now().millisecondsSinceEpoch.toString(),
          userData["id"]);

      await ChatMessageApi().saveMessageInUserCollection(
          userData["id"],
          pData["id"],
          newChatId,
          "You block this contact",
          isBlock: true,
          userData["id"],
          userData["name"]);
    }
    getChatData();
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile() async {
    imageFile = pickerCtrl.imageFile;
    update();

    if (imageFile!.name.contains(".mp4")) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content:const Text("Only png accept"),
        backgroundColor: appCtrl.appTheme.redColor,
      ));
    } else {
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
          onSendMessage(imageUrl!,
              type.contains(".mp4") ? MessageType.video : MessageType.image);
          update();
        }, onError: (err) {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: 'Image is Not Valid');
        });
      });
    }
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

  uploadCameraImage() async {
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

  //send video after recording or pick from media
  videoSend() async {
    update();
    videoFile = pickerCtrl.videoFile;
    update();
    log("videoFile : $videoFile");
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
    }).then((value) {
      videoFile = null;
      pickerCtrl.videoFile = null;

      pickerCtrl.video = null;
      videoUrl = "";
      update();
      pickerCtrl.update();
    });
  }
  

  //pick up contact and share
  saveContactInChat(value) async {
    if (value != null) {
      FirebaseContactModel contact = value;
      log("ccc : $contact");
      String? photo;
      isLoading = true;
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .where("phone", isEqualTo: contact.phone)
          .get()
          .then((user) {
        if (user.docs.isNotEmpty) {
          photo = user.docs[0].data()["image"] ?? "";
        }
      });
      update();
      onSendMessage('${contact.name}-BREAK-${contact.phone}-BREAK-$photo',
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
      Uri blobUri = Uri.parse(value);
      http.Response response = await http.get(blobUri);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putData(
          response.bodyBytes, SettableMetadata(contentType: 'video/mp4'));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      log("audioFile : $downloadUrl");
      onSendMessage(downloadUrl, MessageType.audio);
      log("audioFile : $downloadUrl");
    });
  }

  // SEND MESSAGE CLICK

  // SEND MESSAGE CLICK
  void onSendMessage(String content, MessageType type) async {
    log("allData : $allData");
    // isLoading = true;
    update();
    Get.forceAppUpdate();
    log("check for send ");
    final key = encrypt.Key.fromUtf8('my 32 length key................');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(content, iv: iv).base64;

    if (content.trim() != '') {
      textEditingController.clear();
      final now = DateTime.now();
      String? newChatId =
      chatId == "0" ? now.microsecondsSinceEpoch.toString() : chatId;
      chatId = newChatId;
      update();
      imageUrl = "";

      update();

      if (allData != null && allData != "") {
        if (allData["isBlock"] == true) {
          if (allData["blockUserId"] == pId) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(content: Text(fonts.unblockUser(pName))));
          } else {
            ChatMessageApi()
                .saveMessage(
                newChatId,
                pId,
                encrypted,
                type,
                DateTime.now().millisecondsSinceEpoch.toString(),
                userData["id"])
                .then((snap) async {
              isLoading = false;
              update();
              Get.forceAppUpdate();
              if (type.name != MessageType.note.name) {
                await ChatMessageApi().saveMessageInUserCollection(
                    pData["id"],
                    userData["id"],
                    newChatId,
                    encrypted,
                    userData["id"],
                    pName);
              }
            }).then((value) {
              isLoading = false;
              update();
              Get.forceAppUpdate();
            });
          }
          isLoading = false;
          update();
        } else {
          ChatMessageApi()
              .saveMessage(
              newChatId,
              pId,
              encrypted,
              type,
              DateTime.now().millisecondsSinceEpoch.toString(),
              userData["id"])
              .then((value) {
            ChatMessageApi()
                .saveMessage(newChatId, pId, encrypted, type,
                DateTime.now().millisecondsSinceEpoch.toString(), pId)
                .then((snap) async {
              isLoading = false;
              update();
              Get.forceAppUpdate();
              if (type.name != MessageType.note.name) {
                await ChatMessageApi().saveMessageInUserCollection(
                    userData["id"],
                    pId,
                    newChatId,
                    encrypted,
                    userData["id"],
                    pName);
                await ChatMessageApi().saveMessageInUserCollection(pId, pId,
                    newChatId, encrypted, userData["id"], userData["name"]);
              }
            }).then((value) {
              isLoading = false;
              update();
              Get.forceAppUpdate();
            });
          });
        }
        isLoading = false;
        update();
        Get.forceAppUpdate();
      } else {
        log("message se");
        isLoading = false;
        update();

        ChatMessageApi()
            .saveMessage(
            newChatId,
            pId,
            encrypted,
            type,
            DateTime.now().millisecondsSinceEpoch.toString(),
            userData["id"])
            .then((value) {
          ChatMessageApi()
              .saveMessage(newChatId, pId, encrypted, type,
              DateTime.now().millisecondsSinceEpoch.toString(), pId)
              .then((snap) async {
            isLoading = false;
            update();
            Get.forceAppUpdate();
            log("check");

            if (type.name != MessageType.note.name) {
              await ChatMessageApi().saveMessageInUserCollection(userData["id"],
                  pId, newChatId, encrypted, userData["id"], pName);
              await ChatMessageApi().saveMessageInUserCollection(pId, pId,
                  newChatId, encrypted, userData["id"], userData["name"]);
            }
          }).then((value) {
            isLoading = false;
            update();
            Get.forceAppUpdate();
            if (type != MessageType.note) {
              getChatData();
            }
          });
        });
      }
    }
    if (type != MessageType.note) {
      if (chatId != "0") {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .collection(collectionName.chats)
            .where("chatId", isEqualTo: chatId)
            .get()
            .then((value) {
          log("allData : ${value.docs[0].data()}");
          allData = value.docs[0].data();
          clearChatId = allData["clearChatId"] ?? [];
          update();
        });
      }
    }
    seenMessage();
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(pId)
        .get()
        .then((value) {
      pData = value.data();

      update();
      log("get L : $pData");
    });
    if (pData["pushToken"] != "") {
      firebaseCtrl.sendNotification(
          title: "Single Message",
          msg: content,
          chatId: chatId,
          token: pData["pushToken"],
          pId: pId,
          pName: pName,
          userContactModel: userContactModel,
          image: userData["image"],
          dataTitle: pName);
    }
    isLoading = false;
    if (allData == null) {
      getChatData();
    }
    update();
    Get.forceAppUpdate();
  }

  //delete chat layout
  buildPopupDialog(docId) async {
    await showDialog(
        context: Get.context!,
        builder: (_) => DeleteAlert(
              docId: docId,
            ));
  }

  wallPaperConfirmation(image) async {
    Get.generalDialog(
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GetBuilder<ChatController>(builder: (chatCtrl) {
              return Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 250,
                      color: appCtrl.appTheme.whiteColor,
                      margin: const EdgeInsets.symmetric(
                          horizontal: Insets.i10, vertical: Insets.i15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Insets.i10, vertical: Insets.i15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Set Wallpaper",
                            style: AppCss.poppinsblack14
                                .textColor(appCtrl.appTheme.blackColor),
                          ),
                          ListTile(
                            title: Text('Set For this chat "$pName"'),
                            leading: Radio(
                              value: "Person Name",
                              groupValue: wallPaperType,
                              onChanged: (String? value) {
                                wallPaperType = value;
                                update();
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('For all chats'),
                            leading: Radio(
                              value: "For All",
                              groupValue: wallPaperType,
                              onChanged: (String? value) {
                                wallPaperType = value;
                                update();
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: CommonButton(
                                title: fonts.cancel.tr,
                                onTap: () => Get.back(),
                                style: AppCss.poppinsMedium14
                                    .textColor(appCtrl.appTheme.white),
                              )),
                              const HSpace(Sizes.s10),
                              Expanded(
                                  child: CommonButton(
                                      onTap: () async {
                                        Get.back();
                                        log("wallPaperType : $image");
                                        if (wallPaperType == "Person Name") {
                                          await FirebaseFirestore.instance
                                              .collection(collectionName.users)
                                              .doc(userData["id"])
                                              .collection(collectionName.chats)
                                              .where("chatId",
                                                  isEqualTo: chatId)
                                              .limit(1)
                                              .get()
                                              .then((userChat) {
                                            if (userChat.docs.isNotEmpty) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      collectionName.users)
                                                  .doc(userData["id"])
                                                  .collection(
                                                      collectionName.chats)
                                                  .doc(userChat.docs[0].id)
                                                  .update({
                                                'backgroundImage': image
                                              });
                                            }
                                          });
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection(collectionName.users)
                                              .doc(userData["id"])
                                              .update(
                                                  {'backgroundImage': image});
                                        }
                                        chatCtrl.allData["backgroundImage"] =
                                            image;
                                        chatCtrl.update();
                                      },
                                      title: fonts.ok.tr,
                                      style: AppCss.poppinsMedium14
                                          .textColor(appCtrl.appTheme.white))),
                            ],
                          )
                        ],
                      )));
            });
          }),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(anim1),
            child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget timeLayout(document) {
    List newMessageList  = document["message"];
    log("newMessageList : $newMessageList");
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
  Widget buildItem(int index, document, documentId) {
     if (document['sender'] == userData["id"]) {
      return SenderMessage(
        document: document,
        index: index,
        docId: documentId,
      ).inkWell(onTap: () {
        enableReactionPopup = false;
        showPopUp = false;
        selectedIndexId = [];
        update();
        log("enable : $enableReactionPopup");
      });
    } else if (document['sender'] != userData["id"]) {
      // RECEIVER MESSAGE
      return document["type"] == MessageType.messageType.name
          ? Container()
          : document["isBlock"]
          ? Container()
          : ReceiverMessage(
          document: document, index: index, docId: documentId)
          .inkWell(onTap: () {
        enableReactionPopup = false;
        showPopUp = false;
        selectedIndexId = [];
        update();
        log("enable : $enableReactionPopup");
      });
    } else {
      return Container();
    }
  }

  // ON BACK PRESS
  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection(collectionName.messages)
        .doc(chatId)
        .collection(collectionName.chat)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        if (value.docs.length == 1) {
          FirebaseFirestore.instance
              .collection(collectionName.messages)
              .doc(chatId)
              .collection(collectionName.chat)
              .doc(value.docs[0].id)
              .delete();
        }
      }
    });
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
