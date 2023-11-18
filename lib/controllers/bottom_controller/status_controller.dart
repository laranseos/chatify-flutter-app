import 'dart:async';
import 'dart:io';
import 'package:chatify_web/config.dart';
import 'package:chatify_web/controllers/bottom_controller/status_firebase_api.dart';
import 'package:chatify_web/screens/dashboard_pages/status/layouts/status_view.dart';


class StatusController extends GetxController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  List<Contact> contactList = [];
  List<Status> status = [];
  String? groupId, currentUserId, imageUrl;
  Image? contactPhoto;
  dynamic user;
  XFile? imageFile;
  File? image;
  bool isLoading = false;
  List selectedContact = [];
  Stream<QuerySnapshot>? stream;
  List<Status> statusListData = [];
  List<Status> statusData = [];
  DateTime date = DateTime.now();
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());

  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());

  @override
  void onReady() async {
    // TODO: implement onReady
    final data = appCtrl.storage.read(session.user) ?? "";
    if (data != "") {
      currentUserId = data["id"];
      user = data;
    }
    update();

    debugPrint("contactList : ${appCtrl.userContactList}");
    update();

    super.onReady();
  }

// Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //add status
  addStatus(File file, StatusType statusType) async {
    isLoading = true;
    update();
    imageUrl = await pickerCtrl.uploadImage(file);
    if(imageUrl != "") {
      update();
      debugPrint("imageUrl : $imageUrl");
      await StatusFirebaseApi().addStatus(imageUrl, statusType.name);
    }else{
      showToast("Error while Uploading Image");
    }
    isLoading = false;
    update();
  }

  //status list

  List statusListWidget(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List statusList = [];
    for (int a = 0; a < snapshot.data!.docs.length; a++) {
      statusList.add(snapshot.data!.docs[a].data());
    }
    return statusList;
  }

  openImagePreview(status) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape:const  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(AppRadius.r12))),
                backgroundColor: appCtrl.appTheme.blackColor.withOpacity(0.6),

                content: SizedBox(
                    child: SingleChildScrollView(
                        child: Column(children: [
                          StatusScreenView(statusData: status).height(940).width(665),

                        ]))).paddingAll(Insets.i30));
          });
        });
  }

}
