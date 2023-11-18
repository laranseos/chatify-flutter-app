import 'dart:developer';

import 'package:chatify_web/screens/dashboard_pages/group_chat_message/group_message_api.dart';

import '../../../../config.dart';
import '../../../../widgets/common_note_encrypt.dart';

class GroupMessageBox extends StatelessWidget {
  const GroupMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      log("USER : ${chatCtrl.pId}");

      return    Flexible(
          child: chatCtrl.user == null
              ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      appCtrl.appTheme.primary)))
              : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.groupMessage)
                  .doc(chatCtrl.pId)
                  .collection(collectionName.chat)
                  .orderBy('timestamp', descending: true)
                  .limit(chatCtrl.pageSize)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              appCtrl.appTheme.primary)));
                } else {
                  GroupMessageApi().getMessageAsPerDate(snapshot);

                  return ListView(
                    controller: chatCtrl.listScrollController,
                    reverse: true,
                    children: [
                      ...chatCtrl.message.reversed
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => chatCtrl
                          .timeLayout(
                        e.value,
                      )
                          .marginOnly(bottom: Insets.i18))
                          .toList(),
                      Container(
                          margin: const EdgeInsets.only(bottom: 2.0),
                          padding: const EdgeInsets.only(
                              left: Insets.i10, right: Insets.i10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Align(
                                alignment: Alignment.center,
                                child: CommonNoteEncrypt(),
                              ).paddingOnly(bottom: Insets.i8)
                            ],
                          )),
                    ],
                  );
                }
              }));
    });
  }
}
