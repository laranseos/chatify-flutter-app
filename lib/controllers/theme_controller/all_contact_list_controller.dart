

import 'dart:developer';

import 'package:chatify_web/config.dart';
import 'package:chatify_web/models/firebase_contact_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


class AllContactListController extends GetxController {

  List<FirebaseContactModel> storageContact = [];
  List<FirebaseContactModel> allContact = [];
  bool isLoading = true;
  int counter = 0;
  static const pageSize = 20;
   PagingController<int, FirebaseContactModel> pagingController =
      PagingController(firstPageKey: 0);
  TextEditingController searchText = TextEditingController();


  @override
  void onReady() async {
    // TODO: implement onReady
    update();

    super.onReady();
  }

  onSearchData(val)async{
    log("VLAUE : $val");allContact = [];
   /* appCtrl.contactList.asMap().entries.forEach((element) {
      if(element.value.name!.toLowerCase().contains(val)){
        if(!allContact.contains(element.value)){
          allContact.add(element.value);
        }else{
          allContact.remove(element.value);
        }
        update();
      }
    });
    log("ALLL : ${allContact.length}");*/
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit

    update();
    super.onInit();
  }
}
