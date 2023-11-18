import 'package:intl/intl.dart';

import '../../../../config.dart';

class BroadCastMessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId;

  const BroadCastMessageCard({Key? key, this.document, this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List selectedContact = document!["receiverId"];
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  height: Sizes.s40,
                  width: Sizes.s40,
                  decoration: ShapeDecoration(
                      color: appCtrl.appTheme.grey.withOpacity(.4),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 12, cornerSmoothing: 1),
                      )),
                  child: Icon(Icons.volume_down,
                      color: appCtrl.appTheme.blackColor)),
              const HSpace(Sizes.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${selectedContact.length} recipient",
                      style: AppCss.poppinsblack14
                          .textColor(appCtrl.appTheme.blackColor)),
                  const VSpace(Sizes.s5),
                  Text(decryptMessage(document!["lastMessage"]),
                      overflow: TextOverflow.ellipsis,
                      style: AppCss.poppinsMedium14
                          .textColor(appCtrl.appTheme.txtColor))
                ],
              ),
            ],
          ),
          Text(
                  DateFormat('HH:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document!['updateStamp']))),
                  style: AppCss.poppinsMedium12
                      .textColor(appCtrl.appTheme.txtColor))
              .paddingOnly(top: Insets.i8)
        ],
      )
          .paddingSymmetric(vertical: Insets.i10)
          .paddingSymmetric(
              horizontal:  indexCtrl.chatId == document!["broadcastId"]
          ? 0
          : Insets.i22,
              vertical: Insets.i5)
          .commonDecoration()
          .marginSymmetric(horizontal:  indexCtrl.chatId == document!["broadcastId"]
          ? Insets.i10
          : 0)
          .inkWell(onTap: () {
        var data = {
          "broadcastId": document!["broadcastId"],
          "data": document!.data(),
        };
        indexCtrl.chatId = document!["broadcastId"];
        indexCtrl.chatType = 2;
        indexCtrl.update();
        final chatCtrl = Get.isRegistered<BroadcastChatController>()
            ? Get.find<BroadcastChatController>()
            : Get.put(BroadcastChatController());
        chatCtrl.data = data;
        chatCtrl.pId = document!["broadcastId"];
        chatCtrl.onReady();
        chatCtrl.update();
      });
    });
  }
}
