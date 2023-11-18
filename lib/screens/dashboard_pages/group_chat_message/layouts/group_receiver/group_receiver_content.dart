

import 'package:intl/intl.dart';
import '../../../../../config.dart';

class GroupReceiverContent extends StatelessWidget {
  final DocumentSnapshot? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
final bool isSearch;
  const GroupReceiverContent({Key? key, this.document, this.onLongPress,this.onTap,this.isSearch =false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(document!['sender'])
            .snapshots(),
        builder: (context, snapshot) {
          return InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    decryptMessage(document!['content']).length > 40
                        ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Insets.i12, vertical: Insets.i14),
                        width: Sizes.s230,
                        decoration: ShapeDecoration(
                          color: appCtrl.appTheme.chatSecondaryColor,
                          shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.only(
                                  topLeft:
                                  SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                                  topRight: SmoothRadius(
                                      cornerRadius: 20, cornerSmoothing: 1),
                                  bottomRight: SmoothRadius(
                                      cornerRadius: 20,
                                      cornerSmoothing: 1
                                  ))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ Text("${document!['senderName']}",
                              style: AppCss.poppinsSemiBold12
                                  .textColor(appCtrl.appTheme.primary)),
                            const VSpace(Sizes.s6),
                            Text(decryptMessage(document!['content']),
                                style: AppCss.poppinsMedium14
                                    .textColor(appCtrl.appTheme.blackColor)
                                    .letterSpace(.2)
                                    .textHeight(1.2)).alignment(Alignment.centerLeft).backgroundColor(isSearch ? appCtrl.appTheme.orangeColor.withOpacity(.5) : appCtrl.appTheme.transparentColor),
                          ],
                        )) : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Insets.i12, vertical: Insets.i14),
                        decoration: ShapeDecoration(
                          color: appCtrl.appTheme.chatSecondaryColor,
                          shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.only(
                                  topLeft:
                                  SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                                  topRight: SmoothRadius(
                                      cornerRadius: 20, cornerSmoothing: 1),
                                  bottomRight: SmoothRadius(
                                      cornerRadius: 20,
                                      cornerSmoothing: 1
                                  ))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ Text("${document!['senderName']}",
                              style: AppCss.poppinsSemiBold12
                                  .textColor(appCtrl.appTheme.primary)),
                            const VSpace(Sizes.s6),
                            Text(decryptMessage(document!['content']),
                                style: AppCss.poppinsMedium14
                                    .textColor(appCtrl.appTheme.blackColor)
                                    .letterSpace(.2)
                                    .textHeight(1.2)).alignment(Alignment.centerLeft),
                          ],
                        )),
                    if (document!.data().toString().contains('emoji'))
                      EmojiLayout(emoji: document!["emoji"])
                  ],
                ),
                const VSpace(Sizes.s5),
                IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                    )
                )
              ],
            ).marginSymmetric(vertical: Insets.i5, horizontal: Insets.i10),
          );
        });
  }
}
