import 'dart:developer';

import 'package:chatify_web/config.dart';

class CallListController extends GetxController {
  List settingList = [];
  dynamic user;

  DateTime now = DateTime.now();

  @override
  void onReady() {
    // TODO: implement onReady
    settingList = appArray.settingList;
    user = appCtrl.storage.read(session.user) ?? "";
    update();
   // callList();
    super.onReady();
  }

  editProfile() {
    user = appCtrl.storage.read(session.user);

    Get.toNamed(routeName.editProfile,
        arguments: {"resultData": user, "isPhoneLogin": false});
  }

  callList()async{
    int count= 0;
    FirebaseFirestore.instance.collection(collectionName.users).get().then((value) {
      if(value.docs.isNotEmpty){
       value.docs.asMap().entries.forEach((e) {

         FirebaseFirestore.instance
             .collection(collectionName.calls)
             .doc(e.value.id)
             .collection(collectionName.collectionCallHistory)
             .get().then((value) {

           count = count + value.docs.length;
           update();
           log("COUNT : $count");
         });
       });
      }

    });

  }
}
