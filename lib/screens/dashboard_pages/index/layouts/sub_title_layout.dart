import '../../../../config.dart';

class SubTitleLayout extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? blockBy,name;
  const SubTitleLayout({Key? key,this.document,this.name,this.blockBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.done_all,
            color: document!["isSeen"]
                ? appCtrl.isTheme ?appCtrl.appTheme.white : appCtrl.appTheme.primary
                : appCtrl.appTheme.grey,
            size: Sizes.s16),
        const HSpace(Sizes.s10),
        decryptMessage(document!["lastMessage"]).contains(".gif") ?const Icon(Icons.gif_box) :
        Text(
            (decryptMessage(document!["lastMessage"]).contains("media")) ? "You Share Media" :   document!["isBlock"] == true &&
                document!["isBlock"] == "true"
                ? document!["blockBy"] != blockBy
                ? document!["blockUserMessage"]
                : decryptMessage(document!["lastMessage"])
                .contains("http")
                :  (decryptMessage(document!["lastMessage"]).contains(".pdf") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".doc") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".mp3") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".mp4") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".xlsx") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".ods"))
                ? decryptMessage(document!["lastMessage"])
                .split("-BREAK-")[0]
                : decryptMessage(document!["lastMessage"]),
            style: AppCss.poppinsMedium14
                .textColor(appCtrl.appTheme.txtColor).textHeight(1.2).letterSpace(.2),
            overflow: TextOverflow.ellipsis).width(Sizes.s150),
      ],
    );
  }
}
