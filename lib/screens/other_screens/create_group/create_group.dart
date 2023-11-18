import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config.dart';
import 'layouts/all_registered_contact.dart';
import 'layouts/selected_contact_list.dart';

class GroupChat extends StatelessWidget {
  final SharedPreferences? prefs;
  final groupChatCtrl = Get.isRegistered<CreateGroupController>()
      ? Get.find<CreateGroupController>()
      : Get.put(CreateGroupController());

  GroupChat({Key? key, this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context2, setState) {
      return GetBuilder<CreateGroupController>(builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            groupChatCtrl.selectedContact = [];
            groupChatCtrl.update();
            Get.back();
            return true;
          },
          child: GetBuilder<AppController>(builder: (appCtrl) {
            log("groupChatCtrl.isAddUser : ${groupChatCtrl.isGroup}");
            return Consumer<FetchContactController>(
                builder: (context1, registerAvailableContact, child) {
              return Scaffold(
                  backgroundColor: appCtrl.appTheme.whiteColor,
                  appBar: AppBar(
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      actions: [
                        Icon(
                          groupChatCtrl.selectedContact.isNotEmpty
                              ? Icons.arrow_right_alt
                              : Icons.refresh,
                          color: appCtrl.appTheme.white,
                        ).marginSymmetric(horizontal: Insets.i15).inkWell(
                            onTap: () =>
                                groupChatCtrl.selectedContact.isNotEmpty
                                    ? groupChatCtrl.addGroupBottomSheet(context)
                                    : registerAvailableContact
                                        .syncContactsFromCloud(context, prefs!))
                      ],
                      leading: Icon(Icons.arrow_back,
                              color: appCtrl.appTheme.whiteColor)
                          .inkWell(onTap: () => Get.back()),
                      backgroundColor: appCtrl.appTheme.primary,
                      title: Text(
                          groupChatCtrl.isAddUser
                              ? fonts.addContact.tr
                              : groupChatCtrl.isGroup
                                  ? fonts.selectContacts.tr
                                  : fonts.broadCast.tr,
                          style: AppCss.poppinsMedium18
                              .textColor(appCtrl.appTheme.whiteColor))),
                  body: Stack(children: [
                    SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          if (groupChatCtrl.selectedContact.isNotEmpty)
                            SelectedContactList(
                              selectedContact: groupChatCtrl.selectedContact,
                              onTap: (p0) {
                                groupChatCtrl.selectedContact.remove(p0);
                                groupChatCtrl.update();
                              },
                            ),
                          registerAvailableContact
                                  .alreadyRegisterUser.isNotEmpty
                              ? Column(children: [
                                  ...registerAvailableContact
                                      .alreadyRegisterUser
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    return AllRegisteredContact(
                                        onTap: () => groupChatCtrl
                                            .selectUserTap(e.value),
                                        isExist: groupChatCtrl.selectedContact
                                            .any((file) =>
                                                file["phone"] == e.value.phone),
                                        data: e.value);
                                  }).toList()
                                ])
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('New Register?',
                                          style: AppCss.poppinsBold16
                                              .textColor(appCtrl.appTheme.txt)),
                                      const VSpace(Sizes.s15),
                                      Text(
                                          "Sync Your contact from app. For that Download the app your in to your account\nNow go to Setting in that click on Sync now text button.",
                                          style: AppCss.poppinsMedium14
                                              .textColor(appCtrl.appTheme.txt))
                                    ],
                                  )
                                      .height(
                                          MediaQuery.of(context).size.height /
                                              2.5)
                                      .paddingSymmetric(horizontal: Insets.i15),
                                )
                        ]).height(MediaQuery.of(context).size.height)),
                  ]).height(MediaQuery.of(context).size.height));
            });
          }),
        );
      });
    });
  }
}
