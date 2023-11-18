import 'dart:developer';

import 'package:chatify_web/widgets/common_note_encrypt.dart';

import '../../../../config.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      log("USER : ${appCtrl.user["id"]}");
      log("USER : ${chatCtrl.chatId}");
      /* return Flexible(
        child: chatCtrl.chatId == null
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            appCtrl.appTheme.primary)))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(collectionName.users)
                        .doc(appCtrl.user["id"])
                        .collection(collectionName.messages)
                        .doc(chatCtrl.chatId)
                        .collection(collectionName.chat)
                        .orderBy('timestamp', descending: true)
                        .limit(20)
                        .snapshots(),
                    builder: (context, snapshot) {
                      log("HAS : ${snapshot.hasData}");
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    appCtrl.appTheme.primary)));
                      } else {
                        log("snapshot : ${snapshot.data!.docs.length}");
                        ChatMessageApi().getMessageAsPerDate(snapshot);

                        return ListView.builder(
                            itemBuilder: (context, index) {
                              return chatCtrl
                                  .timeLayout(
                                    chatCtrl.message[index],
                                  )
                                  .marginOnly(bottom: Insets.i18);
                            },
                            itemCount: chatCtrl.message.length,
                            reverse: true,
                            controller: chatCtrl.listScrollController);
                      }
                    },
                  ),
      );*/
      return Flexible(
          child: chatCtrl.chatId == null
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          appCtrl.appTheme.primary)))
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(appCtrl.user["id"])
                      .collection(collectionName.messages)
                      .doc(chatCtrl.chatId)
                      .collection(collectionName.chat)
                      .orderBy('timestamp', descending: true)
                      .limit(20)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  appCtrl.appTheme.primary)));
                    } else {
                      ChatMessageApi().getMessageAsPerDate(snapshot);

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
