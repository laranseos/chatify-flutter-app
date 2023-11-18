import 'package:chatify_web/screens/dashboard_pages/index/layouts/broadcast_card.dart';
import 'package:chatify_web/screens/dashboard_pages/index/layouts/group_message_card.dart';
import 'package:chatify_web/screens/dashboard_pages/index/layouts/receiver_message_card.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';
import 'message_card.dart';

class LoadUser extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;
  final IndexController? indexCtrl;

  const LoadUser(
      {Key? key,
      this.document,
      this.currentUserId,
      this.blockBy,
      this.indexCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (document!["isGroup"] == false && document!["isBroadcast"] == false) {
      if (document!["senderId"] == currentUserId) {
        return SmoothContainer(
          color: indexCtrl!.chatId == document!["chatId"]
              ? appCtrl.appTheme.whiteColor
              : appCtrl.appTheme.transparentColor,
          smoothness: 1,
          margin: EdgeInsets.symmetric(
              horizontal:
              indexCtrl!.chatId == document!["chatId"]
                  ? Insets.i10
                  : 0),
          foregroundDecoration: BoxDecoration(
              backgroundBlendMode: BlendMode.srcIn,
              color: indexCtrl!.chatId == document!["chatId"]
                  ? appCtrl.appTheme.whiteColor
                  : appCtrl.appTheme.transparentColor,
              boxShadow: indexCtrl!.chatId == document!["chatId"]
                  ? const [
                      BoxShadow(
                          color: Color.fromRGBO(49, 100, 189, 0.08),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ]
                  : null),
          borderRadius: BorderRadius.circular(AppRadius.r10),
          child: ReceiverMessageCard(
              document: document,
              currentUserId: currentUserId,
              blockBy: blockBy),
        );
      } else {
        return SmoothContainer(
          color: indexCtrl!.chatId == document!["chatId"]
              ? appCtrl.appTheme.whiteColor
              : appCtrl.appTheme.transparentColor,
          smoothness: 1,
          margin: EdgeInsets.symmetric(
              horizontal:
              indexCtrl!.chatId == document!["chatId"]
                  ? Insets.i10
                  : 0),
          foregroundDecoration: BoxDecoration(
              backgroundBlendMode: BlendMode.srcIn,
              color: indexCtrl!.chatId == document!["chatId"]
                  ? appCtrl.appTheme.whiteColor
                  : appCtrl.appTheme.transparentColor,
              boxShadow: indexCtrl!.chatId == document!["chatId"]
                  ? const [
                      BoxShadow(
                          color: Color.fromRGBO(49, 100, 189, 0.08),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ]
                  : null),
          borderRadius: BorderRadius.circular(AppRadius.r10),
          child: MessageCard(
              blockBy: blockBy,
              document: document,
              currentUserId: currentUserId),
        );
      }
    } else if (document!["isGroup"] == true) {
      List user = document!["receiverId"];
      return user.where((element) => element["id"] == currentUserId).isNotEmpty
          ? SmoothContainer(
              color: indexCtrl!.chatId == document!["groupId"]
                  ? appCtrl.appTheme.whiteColor
                  : appCtrl.appTheme.transparentColor,
              smoothness: 1,
              margin: EdgeInsets.symmetric(
                  horizontal: indexCtrl!.chatId == document!["groupId"]
                      ? Insets.i10
                      : 0),
              foregroundDecoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.srcIn,
                  color: indexCtrl!.chatId == document!["groupId"]
                      ? appCtrl.appTheme.whiteColor
                      : appCtrl.appTheme.transparentColor,
                  boxShadow: indexCtrl!.chatId == document!["groupId"]
                      ? const [
                          BoxShadow(
                              color: Color.fromRGBO(49, 100, 189, 0.08),
                              blurRadius: 8,
                              spreadRadius: 2)
                        ]
                      : null),
              borderRadius: BorderRadius.circular(AppRadius.r10),
              child: GroupMessageCard(
                  document: document, currentUserId: currentUserId))
          : Container();
    } else if (document!["isBroadcast"] == true) {
      return document!["senderId"] == currentUserId
          ? SmoothContainer(
              color: indexCtrl!.chatId == document!["broadcastId"]
                  ? appCtrl.appTheme.whiteColor
                  : appCtrl.appTheme.transparentColor,
              smoothness: 1,
              margin: EdgeInsets.symmetric(
                  horizontal: indexCtrl!.chatId == document!["broadcastId"]
                      ? Insets.i10
                      : 0),
              foregroundDecoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.srcIn,
                  color: indexCtrl!.chatId == document!["broadcastId"]
                      ? appCtrl.appTheme.whiteColor
                      : appCtrl.appTheme.transparentColor,
                  boxShadow: indexCtrl!.chatId == document!["broadcastId"]
                      ? const [
                          BoxShadow(
                              color: Color.fromRGBO(49, 100, 189, 0.08),
                              blurRadius: 8,
                              spreadRadius: 2)
                        ]
                      : null),
              borderRadius: BorderRadius.circular(AppRadius.r10),
              child: BroadCastMessageCard(
                document: document,
                currentUserId: currentUserId,
              ))
          : MessageCard(
              document: document,
              currentUserId: currentUserId,
              blockBy: blockBy);
    } else {
      return Container();
    }
  }
}
