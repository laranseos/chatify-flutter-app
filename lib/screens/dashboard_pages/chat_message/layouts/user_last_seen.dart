import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../config.dart';

class UserLastSeen extends StatelessWidget {
  const UserLastSeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where("id", isEqualTo: chatCtrl.pId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                log("TIME : ${snapshot.data!.docs[0].data()}");
                return chatCtrl.chatId == "0"
                    ? Container()
                    : Text(
                        snapshot.data!.docs[0]["status"] == "Offline"
                            ? DateFormat('HH:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(
                                    snapshot.data!.docs[0].data()['lastSeen'])))
                            : snapshot.data!.docs[0]["status"],
                        textAlign: TextAlign.center,
                        style: AppCss.poppinsLight14
                            .textColor(appCtrl.appTheme.txtColor),
                      );
              }
            } else {
              return Container();
            }
          });
    });
  }
}
