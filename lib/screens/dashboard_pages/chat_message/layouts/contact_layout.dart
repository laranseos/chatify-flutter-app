import 'package:chatify_web/controllers/bottom_controller/message_firebase_api.dart';
import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../../../../config.dart';

class ContactLayout extends StatelessWidget {
  final dynamic document;
  final VoidCallback? onLongPress, onTap;

  final bool isReceiver, isBroadcast;

  const ContactLayout(
      {Key? key,
      this.document,
      this.onLongPress,
      this.onTap,
      this.isReceiver = false,
      this.isBroadcast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [

              Stack(
                children: [
                  SmoothContainer(
                    smoothness: 1,
                      color: isReceiver
                          ? appCtrl.appTheme.chatSecondaryColor
                          : appCtrl.appTheme.primary,
                      borderRadius: BorderRadius.only(
                          topLeft:const Radius.circular(AppRadius.r20),
                          topRight:const Radius.circular(AppRadius.r20),
                          bottomLeft: Radius.circular( isReceiver ? 0 : 20),
                          bottomRight: Radius.circular( isReceiver ? 20 : 0)
                      ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ContactListTile(
                                  document: document, isReceiver: isReceiver)
                                  .marginOnly(top: Insets.i5)
                            ]).border(bottom: 1,color: isReceiver
                            ? appCtrl.appTheme.lightDividerColor.withOpacity(.2)
                            : appCtrl.appTheme.white),
                        const VSpace(Sizes.s10),
                        InkWell(
                            onTap: () {
                              UserContactModel user = UserContactModel(
                                  uid: "0",
                                  isRegister: false,
                                  image: decryptMessage(document!["content"]).split('-BREAK-')[2],
                                  username:
                                  decryptMessage(document!["content"]).split('-BREAK-')[0],
                                  phoneNumber: phoneNumberExtension(
                                      decryptMessage(document!["content"]).split('-BREAK-')[1]),
                                  description: "");
                              MessageFirebaseApi().saveContact(user);
                            },
                            child: Text(fonts.message.tr,
                                textAlign: TextAlign.center,
                                style: AppCss.poppinsExtraBold12.textColor(
                                    isReceiver
                                        ? appCtrl.appTheme.lightBlackColor
                                        : appCtrl.appTheme.white)).marginOnly(bottom: Insets.i20))
                      ]))
                ],
              ),
              if (document!.data().toString().contains('emoji'))
                EmojiLayout(emoji: document!["emoji"])
            ],
          ),
          const VSpace(Sizes.s2),
          IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                if (document!.data().toString().contains('isFavourite'))
                  Icon(Icons.star,
                      color: appCtrl.appTheme.txtColor, size: Sizes.s10),
                const HSpace(Sizes.s3),
            if (!isBroadcast && !isReceiver)
              Icon(Icons.done_all_outlined,
                  size: Sizes.s15,
                  color: document!['isSeen'] == false
                      ? appCtrl.appTheme.primary
                      : appCtrl.appTheme.gray),
            const HSpace(Sizes.s5),
            Text(
                DateFormat('HH:mm a').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document!['timestamp']))),
                style:
                    AppCss.poppinsMedium12.textColor(appCtrl.appTheme.txtColor))
          ]))
        ]).marginSymmetric(horizontal: Insets.i10));
  }
}
