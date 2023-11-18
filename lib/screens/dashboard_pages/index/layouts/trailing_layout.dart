import 'package:intl/intl.dart';

import '../../../../config.dart';

class TrailingLayout extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, unSeenMessage;

  const TrailingLayout(
      {Key? key, this.document, this.currentUserId, this.unSeenMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(builder: (msgCtrl) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                DateFormat('HH:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document!['updateStamp']))),
                style: AppCss.poppinsMedium12.textColor( appCtrl.appTheme.txtColor)),
             (currentUserId == document!["receiverId"])?
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(collectionName.messages)
                      .doc(document!["chatId"])
                      .collection(collectionName.chat)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int number = getUnseenMessagesNumber(snapshot.data!.docs);
                      return number == 0
                          ? Container()
                          : Container(
                              height: Sizes.s20,
                              width: Sizes.s20,alignment: Alignment.center,
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
                                      style: AppCss.poppinsSemiBold10.textColor(
                                          appCtrl.appTheme.whiteColor).textHeight(1.3))
                            );
                    } else {
                      return Container();
                    }
                  }) :Container()
          ]).marginOnly(top: Insets.i8);
    });
  }
}
