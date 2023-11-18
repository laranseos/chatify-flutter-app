import '../../../../config.dart';

class GroupCardSubTitle extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? name, currentUserId;
  final bool hasData;

  const GroupCardSubTitle(
      {Key? key,
      this.document,
      this.name,
      this.currentUserId,
      this.hasData = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (decryptMessage(document!["lastMessage"]).contains(".gif"))
        ? const Icon(
            Icons.gif_box,
            size: Sizes.s20,
          ).alignment(Alignment.centerLeft)
        : Text(
            (decryptMessage(document!["lastMessage"]).contains("media"))
                ? hasData
                    ? "$name Media Share"
                    : "Media Share"
                : (decryptMessage(document!["lastMessage"]).contains(".pdf") ||
                        decryptMessage(document!["lastMessage"]).contains(".doc") ||
                        decryptMessage(document!["lastMessage"]).contains(".mp3") ||
                        decryptMessage(document!["lastMessage"]).contains(".mp4") ||
                        decryptMessage(document!["lastMessage"]).contains(".xlsx") ||
                        decryptMessage(document!["lastMessage"]).contains(".ods"))
                    ? decryptMessage(document!["lastMessage"]).split("-BREAK-")[0]
                    : decryptMessage(document!["lastMessage"]) == ""
                        ? currentUserId == document!["senderId"]
                            ? "You Create this group ${document!["group"]['name']}"
                            : "${document!["sender"]['name']} added you"
                        : decryptMessage(document!["lastMessage"]),
            overflow: TextOverflow.ellipsis,
            style: AppCss.poppinsMedium14
                .textColor(appCtrl.appTheme.txtColor)
                .textHeight(1.2)
                .letterSpace(.2)).width(Sizes.s170);
  }
}
