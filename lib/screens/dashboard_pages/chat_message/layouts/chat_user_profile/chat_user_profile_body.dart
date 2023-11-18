import 'package:chatify_web/screens/dashboard_pages/chat_message/layouts/chat_user_profile/block_report_layout.dart';
import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../../../../../config.dart';
import 'chat_user_images.dart';

class ChatUserProfileBody extends StatelessWidget {
  const ChatUserProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return SmoothContainer(
          color: appCtrl.appTheme.bgColor,
          width: Sizes.s450,
          smoothness: 1,
          height: MediaQuery.of(context).size.height /1.25,
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height /10),
          borderRadius:const BorderRadius.only(topRight: Radius.circular(AppRadius.r20),topLeft: Radius.circular(AppRadius.r20)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SmoothContainer(
                width: MediaQuery.of(context).size.width,

                    color: appCtrl.appTheme.bgColor,
                    borderRadius: BorderRadius.circular(AppRadius.r20),
                child: Column(children: [
                  Text(chatCtrl.pData["name"],
                      style: AppCss.poppinsSemiBold18
                          .textColor(appCtrl.appTheme.blackColor)),
                  const VSpace(Sizes.s10),
                  Text(chatCtrl.pData["phone"],
                      style: AppCss.poppinsSemiBold14
                          .textColor(appCtrl.appTheme.txtColor)),
                  const VSpace(Sizes.s10),
                  Text(
                      chatCtrl.userData["status"] == "Offline"
                          ? DateFormat('HH:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(chatCtrl.userData['lastSeen'])))
                          : chatCtrl.userData["status"],
                      textAlign: TextAlign.center,
                      style: AppCss.poppinsMedium14
                          .textColor(appCtrl.appTheme.grey)),
                  const VSpace(Sizes.s10),
                ])),
            Text(
              chatCtrl.userData["statusDesc"],
              textAlign: TextAlign.center,
              style:
                  AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor),
            )
                .width(MediaQuery.of(context).size.width)
                .paddingAll(Insets.i20)
                .decorated(
                    color: appCtrl.appTheme.chatSecondaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.r20),
                        bottomRight: Radius.circular(AppRadius.r20))),
            const VSpace(Sizes.s5),
            ChatUserImagesVideos(chatId: chatCtrl.chatId),
            const VSpace(Sizes.s5),
            BlockReportLayout(
                icon: chatCtrl.isBlock ? svgAssets.block : svgAssets.unBlock,
                name:
                    "${chatCtrl.isBlock ? fonts.unblock.tr : fonts.block.tr} ${chatCtrl.pName}",
                onTap: () => chatCtrl.blockUser()),
            BlockReportLayout(
                icon: svgAssets.dislike,
                name: "${fonts.report.tr} ${chatCtrl.pName!}",
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection(collectionName.report)
                      .add({
                    "reportFrom": chatCtrl.userData["id"],
                    "reportTo": chatCtrl.pId,
                    "isSingleChat": true,
                    "timestamp": DateTime.now().millisecondsSinceEpoch
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(fonts.reportSend.tr),
                      backgroundColor: appCtrl.appTheme.greenColor,
                    ));
                  });
                }),
            const VSpace(Sizes.s35)
          ]));
    });
  }
}
