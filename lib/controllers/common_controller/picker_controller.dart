import 'dart:developer';
import 'dart:io';
import 'package:chatify_web/config.dart';
import 'package:light_compressor/light_compressor.dart' as light;


class PickerController extends GetxController {
  XFile? imageFile;
  XFile? videoFile;
  File? image;
  File? video;
  String? imageUrl;
  String? audioUrl;

// GET IMAGE FROM GALLERY
  Future getImage(source) async {
    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickMedia(imageQuality: 30))!;
    if (imageFile != null) {

      image = File(imageFile!.path);
      Get.forceAppUpdate();
    }
  }




// GET VIDEO FROM GALLERY
  Future getVideo(source) async {
    appCtrl.isLoading = true;
    update();
    final light.LightCompressor lightCompressor = light.LightCompressor();
    final ImagePicker picker = ImagePicker();
    videoFile = (await picker.pickVideo(
      source: source,
    ))!;
    if (videoFile != null) {
      log("videoFile!.path : ${videoFile!.path}");
      final dynamic response = await lightCompressor.compressVideo(
        path: videoFile!.path,
        videoQuality: light.VideoQuality.very_low,
        isMinBitrateCheckEnabled: false,
        video: light.Video(videoName: videoFile!.name),
        android: light.AndroidConfig(
            isSharedStorage: true, saveAt: light.SaveAt.Movies),
        ios: light.IOSConfig(saveInGallery: false),
      );

      video = File(videoFile!.path);
      if (response is light.OnSuccess) {
        log("videoFile!.path 1: ${getVideoSize(file: File(response.destinationPath))}}");
        video = File(response.destinationPath);
      }
      appCtrl.isLoading = false;
      appCtrl.update();
      update();
    }
    Get.forceAppUpdate();
  }

// FOR Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //image picker option
  imagePickerOption(BuildContext context,
      {isGroup = false, isSingleChat = false, isCreateGroup = false})async {
    await getImage(ImageSource.gallery).then((value) {
      if (isGroup) {
        final chatCtrl = Get.find<GroupChatMessageController>();
        chatCtrl.uploadFile();
      } else if (isSingleChat) {
        final singleChatCtrl = Get.find<ChatController>();
        singleChatCtrl.uploadFile();
      } else if (isCreateGroup) {
        final singleChatCtrl = Get.find<CreateGroupController>();
        singleChatCtrl.uploadFile();
      } else {
        final broadcastCtrl = Get.find<BroadcastChatController>();
        broadcastCtrl.uploadFile();
      }
    });
  }

  //video picker option
  videoPickerOption(BuildContext context,
      {isGroup = false, isSingleChat = false}) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.r25))),
        builder: (BuildContext context) {
          // return your layout
          return ImagePickerLayout(cameraTap: () async {
            dismissKeyboard();
            await getVideo(ImageSource.camera).then((value) {
              if (isGroup) {
                final chatCtrl = Get.find<GroupChatMessageController>();
                chatCtrl.videoSend();
              } else if (isSingleChat) {
                final singleChatCtrl = Get.find<ChatController>();
                singleChatCtrl.videoSend();
              } else {
                final broadcastCtrl = Get.find<BroadcastChatController>();
                broadcastCtrl.videoSend();
              }
            });
            Get.back();
          }, galleryTap: () async {
            await getVideo(ImageSource.gallery).then((value) {
              if (isGroup) {
                final chatCtrl = Get.find<GroupChatMessageController>();
                chatCtrl.videoSend();
              } else if (isSingleChat) {
                final singleChatCtrl = Get.find<ChatController>();
                singleChatCtrl.videoSend();
              } else {
                final broadcastCtrl = Get.find<BroadcastChatController>();
                broadcastCtrl.videoSend();
              }
            });
            Get.back();
          });
        });
  }

  Future<String> uploadImage(File file, {String? fileNameText}) async {
   try{
     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
     Reference reference =
     FirebaseStorage.instance.ref().child(fileNameText ?? fileName);
     UploadTask uploadTask = reference.putFile(file);
     TaskSnapshot snap = await uploadTask;
     String downloadUrl = await snap.ref.getDownloadURL();
     imageUrl = downloadUrl;
     return imageUrl!;
   }on FirebaseException catch (e){
     log("FIREBASE : ${e.message}");
     return "";
   }
  }
}
