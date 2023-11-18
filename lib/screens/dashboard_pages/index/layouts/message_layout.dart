
import 'package:chatify_web/controllers/bottom_controller/message_firebase_api.dart';
import '../../../../config.dart';
import 'load_user.dart';

class MessageLayout extends StatelessWidget {
  const MessageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return Column(
        children: [
          if (indexCtrl.userText.text.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                  vertical: Insets.i20, horizontal: Insets.i10),
              itemBuilder: (context, index) {
                return LoadUser(
                    document: indexCtrl.searchMessage[index],
                    blockBy: indexCtrl.user["id"],
                    currentUserId: indexCtrl.user["id"]);
              },
              itemCount: indexCtrl.searchMessage.length,
            ),
          if (!indexCtrl.userText.text.isNotEmpty)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(indexCtrl.user["id"])
                    .collection(collectionName.chats)
                    .orderBy("updateStamp", descending: true)
                    .limit(15)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CommonEmptyLayout(
                        gif: gifAssets.message,
                        title: fonts.emptyMessageTitle.tr,
                        desc: fonts.emptyMessageDesc.tr);
                  } else if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          appCtrl.appTheme.primary),
                    )).height(MediaQuery.of(context).size.height);
                  } else {
                    indexCtrl.message =
                        MessageFirebaseApi().chatListWidget(snapshot);
                    return !snapshot.hasData
                        ? Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        appCtrl.appTheme.primary)))
                            .height(MediaQuery.of(context).size.height)
                            .expanded()
                        : indexCtrl.message.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                    vertical: Insets.i20,
                                    horizontal: Insets.i10),
                                itemBuilder: (context, index) {
                                  return LoadUser(
                                      indexCtrl: indexCtrl,
                                      document: indexCtrl.message[index],
                                      blockBy: indexCtrl.user["id"],
                                      currentUserId: indexCtrl.user["id"]);
                                },
                                itemCount: indexCtrl.message.length,
                              )
                            : CommonEmptyLayout(
                                gif: gifAssets.message,
                                title: fonts.emptyMessageTitle.tr,
                                desc: fonts.emptyMessageDesc.tr);
                  }
                }),
        ],
      );
    });
  }
}
