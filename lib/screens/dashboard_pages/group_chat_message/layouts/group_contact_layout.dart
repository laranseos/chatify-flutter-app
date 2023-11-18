import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';
import '../../../../controllers/bottom_controller/message_firebase_api.dart';

class GroupContactLayout extends StatelessWidget {
  final DocumentSnapshot? document;
  final VoidCallback? onLongPress,onTap;
  final String? currentUserId;
  final bool isReceiver;

  const GroupContactLayout(
      {Key? key,
      this.document,
      this.onLongPress,
      this.currentUserId,
      this.isReceiver = false,this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            SmoothContainer(
                width: Sizes.s250,
                height: Sizes.s120,
                smoothness: 0.9,

            color: isReceiver
                ? appCtrl.appTheme.chatSecondaryColor
                : appCtrl.appTheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomRight: Radius.circular(isReceiver ? 20 : 0),
                  bottomLeft: Radius.circular(isReceiver ? 0 : 20)
                ),
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (document!["sender"] != currentUserId)
                        Column(children: [
                          Text(document!['senderName'],
                              style: AppCss.poppinsMedium12
                                  .textColor(appCtrl.appTheme.primary)).paddingAll(Insets.i5).decorated(color: appCtrl.appTheme.whiteColor,borderRadius: BorderRadius.circular(AppRadius.r20)),

                        ]),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ContactListTile(
                                document: document, isReceiver: isReceiver)
                                .marginOnly(top: Insets.i5)
                          ]),
                      const VSpace(Sizes.s8),
                      Divider(
                          thickness: 1.5,
                          color: isReceiver
                              ? appCtrl.appTheme.lightDividerColor.withOpacity(.2)
                              : appCtrl.appTheme.white,
                          height: 1),
                      Column(
                        children: [
                          InkWell(
                              onTap: () {
                                UserContactModel user = UserContactModel(
                                    uid: "0",
                                    isRegister: false,
                                    image: decryptMessage(document!['content']).split('-BREAK-')[2],
                                    username:
                                    decryptMessage(document!['content']).split('-BREAK-')[0],
                                    phoneNumber: phoneNumberExtension(
                                        decryptMessage(document!['content']).split('-BREAK-')[1]),
                                    description: "");
                                MessageFirebaseApi().saveContact(user);
                              },
                              child: Text(fonts.message.tr,
                                  textAlign: TextAlign.center,
                                  style: AppCss.poppinsExtraBold12.textColor(
                                      isReceiver
                                          ? appCtrl.appTheme.lightBlackColor
                                          : appCtrl.appTheme.white))
                                  .marginSymmetric(vertical: Insets.i12)),
                          IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (document!.data().toString().contains('isFavourite'))
                                    Icon(Icons.star,color: appCtrl.appTheme.txtColor,size: Sizes.s10),
                                  const HSpace(Sizes.s3),
                                  Text(
                                    DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(document!['timestamp']))),
                                    style:
                                    AppCss.poppinsMedium12.textColor(appCtrl.appTheme.txtColor),
                                  ),
                                ],
                              ).alignment(Alignment.bottomRight).marginSymmetric(horizontal: Insets.i10)
                          )
                        ],
                      )
                    ])),

            if (document!.data().toString().contains('emoji'))
              EmojiLayout(emoji: document!["emoji"])
          ],
        )

            .marginSymmetric(horizontal: Insets.i10, vertical: Insets.i10));
  }
}
