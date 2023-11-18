import 'package:intl/intl.dart';

import '../../../../config.dart';

class DocxLayout extends StatelessWidget {
  final dynamic document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup, isBroadcast;
  final String? currentUserId;

  const DocxLayout(
      {Key? key,
      this.document,
      this.onLongPress,
      this.isReceiver = false,
      this.isGroup = false,
      this.isBroadcast = false,
      this.currentUserId,
      this.onTap})
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
              DocContent(
                      isReceiver: isReceiver,
                      isBroadcast: isBroadcast,
                      document: document,
                      currentUserId: currentUserId,
                      isGroup: isGroup)
                  .paddingAll(Insets.i8)
                  .decorated(
                      color: isReceiver
                          ? appCtrl.appTheme.whiteColor
                          : appCtrl.appTheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.r8))
                  .marginSymmetric(horizontal: Insets.i10, vertical: Insets.i2),
              if (document!.data().toString().contains('emoji'))
                EmojiLayout(emoji: document!["emoji"])
            ]
          ),
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              if (document!.data().toString().contains('isFavourite'))
                Icon(Icons.star,
                    color: appCtrl.appTheme.txtColor, size: Sizes.s10),
              const HSpace(Sizes.s3),
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
                      Icon(Icons.star,
                          color: appCtrl.appTheme.txtColor, size: Sizes.s10),
                    const HSpace(Sizes.s3),
                    Text(
                        DateFormat('HH:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document!['timestamp']))),
                        style: AppCss.poppinsMedium12
                            .textColor(appCtrl.appTheme.txtColor))
                  ]))
            ]).marginSymmetric(vertical: Insets.i3, horizontal: Insets.i10)
          )
        ]));
  }
}
