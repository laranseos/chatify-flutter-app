import 'package:intl/intl.dart';

import '../../../../config.dart';

class DocImageLayout extends StatelessWidget {
  final dynamic document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup, isBroadcast;
  final String? currentUserId;

  const DocImageLayout(
      {Key? key,
      this.document,
      this.onLongPress,
      this.isReceiver = false,
      this.isGroup = false,
      this.currentUserId,
      this.isBroadcast = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Column(
        crossAxisAlignment:
            isReceiver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Stack(clipBehavior: Clip.none, children: [
            Column(
              children: [
                if (isGroup)
                  if (isReceiver)
                    if (document!["sender"] != currentUserId)
                      Align(
                          alignment: Alignment.topLeft,
                          child: Column(children: [
                            Text(document!['senderName'],
                                style: AppCss.poppinsMedium12
                                    .textColor(appCtrl.appTheme.primary)),
                            const VSpace(Sizes.s8)
                          ])),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Image.asset(imageAssets.jpg, height: Sizes.s20),
                        const HSpace(Sizes.s10),
                        Expanded(
                          child: Text(
                            decryptMessage(document!["content"]).split("-BREAK-")[0],
                            textAlign: TextAlign.start,
                            style: AppCss.poppinsMedium12.textColor(isReceiver
                                ? appCtrl.appTheme.lightBlackColor
                                : appCtrl.appTheme.white),
                          ),
                        ),
                      ],
                    )
                        .width(220)
                        .paddingSymmetric(
                            horizontal: Insets.i10, vertical: Insets.i15)
                        .decorated(
                            color: isReceiver
                                ? appCtrl.appTheme.lightGrey1Color
                                : appCtrl.appTheme.lightPrimary,
                            borderRadius: BorderRadius.circular(AppRadius.r8)),
                    const VSpace(Sizes.s2),
                    IntrinsicHeight(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isGroup)
                              if (!isReceiver && !isBroadcast)
                                Icon(Icons.done_all_outlined,
                                    size: Sizes.s15,
                                    color: document!['isSeen'] == true
                                        ? appCtrl.appTheme.primary
                                        : appCtrl.appTheme.gray),
                            const HSpace(Sizes.s5),
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
                          ]).marginSymmetric(
                          vertical: Insets.i3, horizontal: Insets.i10),
                    )
                  ],
                )
              ],
            ),
            if (document!.data().toString().contains('emoji'))
              EmojiLayout(emoji: document!["emoji"])
          ])
        ],
      )
          .paddingAll(Insets.i8)
          .decorated(
              color: isReceiver
                  ? appCtrl.appTheme.whiteColor
                  : appCtrl.appTheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.r8))
          .marginSymmetric(horizontal: Insets.i5, vertical: Insets.i5),
    );
  }
}
