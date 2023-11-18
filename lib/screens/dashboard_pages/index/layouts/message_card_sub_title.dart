import '../../../../config.dart';

class MessageCardSubTitle extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy, name;

  const MessageCardSubTitle(
      {Key? key, this.document, this.currentUserId, this.blockBy, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (currentUserId == document!["senderId"])
        Icon(Icons.done_all,
            color: document!["isSeen"]
                ? appCtrl.isTheme
                    ? appCtrl.appTheme.white
                    : appCtrl.appTheme.primary
                : appCtrl.appTheme.grey,
            size: Sizes.s16),
      if (currentUserId == document!["senderId"]) const HSpace(Sizes.s10),
      Text(
          (decryptMessage(document!["lastMessage"]).contains("media"))
              ? "$name Media Share"
              : document!["isBlock"] == true && document!["isBlock"] == "true"
                  ? document!["blockBy"] != blockBy
                      ? document!["blockUserMessage"]
                      : decryptMessage(document!["lastMessage"]).contains("http")
                  : (decryptMessage(document!["lastMessage"]).contains(".pdf") ||
                          decryptMessage(document!["lastMessage"]).contains(".doc") ||
                          decryptMessage(document!["lastMessage"]).contains(".mp3") ||
                          decryptMessage(document!["lastMessage"]).contains(".mp4") ||
                          decryptMessage(document!["lastMessage"]).contains(".xlsx") ||
                          decryptMessage(document!["lastMessage"]).contains(".ods"))
                      ? decryptMessage(document!["lastMessage"]).split("-BREAK-")[0]
                      : decryptMessage(document!["lastMessage"]),
          style: AppCss.poppinsMedium14
              .textColor(appCtrl.appTheme.txtColor)
              .textHeight(1.2)
              .letterSpace(.2),
          overflow: TextOverflow.clip)
    ]).width(Sizes.s200);
  }
}
