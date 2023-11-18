import 'package:chatify_web/screens/dashboard_pages/index/layouts/group_card_sub_title.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';

class GroupMessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId;

  const GroupMessageCard({Key? key, this.document, this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName.groups)
              .doc(document!["groupId"])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(collectionName.users)
                          .doc(document!["senderId"])
                          .snapshots(),
                      builder: (context, userSnapShot) {
                        if (userSnapShot.hasData) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CommonImage(
                                    image: (snapshot.data!)["image"],
                                    name: (snapshot.data!)["name"],
                                    height: Sizes.s40,
                                    width: Sizes.s40,
                                  ),
                                  const HSpace(Sizes.s12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data!.data()!["name"],
                                          style: AppCss.poppinsblack16
                                              .textColor(
                                                  appCtrl.appTheme.blackColor)),
                                      const VSpace(Sizes.s5),
                                      document!["lastMessage"] != null
                                          ? GroupCardSubTitle(
                                              currentUserId: currentUserId,
                                              name: userSnapShot.data!.data() !=
                                                      null
                                                  ? userSnapShot.data!
                                                          .data()!["name"] ??
                                                      ""
                                                  : "",
                                              document: document,
                                              hasData: userSnapShot.hasData)
                                          : Container(
                                              height: Sizes.s15,
                                            )
                                    ],
                                  ),
                                ],
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(collectionName.groups)
                                      .doc(document!["groupId"])
                                      .collection(collectionName.chat)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      int number = getGroupUnseenMessagesNumber(snapshot.data!.docs);
                                      return Column(
                                        children: [
                                          Text(
                                              DateFormat('HH:mm a').format(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                      int.parse(document!['updateStamp']))),
                                              style: AppCss.poppinsMedium12
                                                  .textColor(currentUserId == document!["senderId"]
                                                  ? appCtrl.appTheme.txtColor
                                                  : number == 0
                                                  ? appCtrl.appTheme.txtColor
                                                  : appCtrl.appTheme.primary)),
                                          if ((currentUserId != document!["senderId"]))
                                            number == 0
                                                ? Container()
                                                : Container(
                                                height: Sizes.s20,
                                                width: Sizes.s20,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(top: Insets.i5),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: RadialGradient(
                                                      colors: [
                                                        appCtrl.appTheme.lightPrimary,
                                                        appCtrl.appTheme.primary
                                                      ],
                                                    )),
                                                child: Text(number.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: AppCss.poppinsSemiBold10
                                                        .textColor(appCtrl.appTheme.whiteColor)
                                                        .textHeight(1.3))),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })
                                  .paddingOnly(top: Insets.i8)
                            ],
                          ).paddingSymmetric(vertical: Insets.i10).inkWell(
                              onTap: () {
                            var data = {
                              "message": document!.data(),
                              "groupData": snapshot.data!.data()
                            };
                            final chatCtrl =
                                Get.isRegistered<GroupChatMessageController>()
                                    ? Get.find<GroupChatMessageController>()
                                    : Get.put(GroupChatMessageController());

                            chatCtrl.data = data;
                            indexCtrl.update();
                            indexCtrl.chatId = document!["groupId"];
                            indexCtrl.chatType = 1;
                            chatCtrl.update();
                            chatCtrl.pId = document!["groupId"];

                            chatCtrl.onReady();
                          });
                        } else {
                          return Container();
                        }
                      })
                  .width(MediaQuery.of(context).size.width)
                  .paddingSymmetric(
                      horizontal: indexCtrl.chatId == document!["groupId"]
                          ? 0
                          : Insets.i24,
                      vertical: Insets.i4)
                  .commonDecoration()
                  .marginSymmetric(horizontal: indexCtrl.chatId == document!["groupId"]
                  ? Insets.i10
                  : 0);
            }
          });
    });
  }
}
