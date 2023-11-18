

import 'dart:developer';

import '../../../../config.dart';

class ExcelLayout extends StatelessWidget {
  final dynamic document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup, isBroadcast;
  final String? currentUserId;

  const ExcelLayout(
      {Key? key,
      this.document,
      this.onLongPress,
      this.isReceiver = false,
      this.isGroup = false,
      this.currentUserId,
      this.onTap,
      this.isBroadcast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("DOCUMENT : $document");
    return InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
               DocContent(isReceiver: isReceiver,isBroadcast: isBroadcast,document: document,currentUserId: currentUserId,isGroup: isGroup),
                const VSpace(Sizes.s2),
                BroadcastClass().timeFavouriteLayout(
                    document!.data().toString().contains('isFavourite'),
                    document!['timestamp'],
                    isGroup,
                    isReceiver,
                    isBroadcast,
                    document!.data().toString().contains('isSeen') ? document["isSeen"] :false)
              ],
            )
                .paddingAll(Insets.i8)
                .decorated(
                    color: isReceiver
                        ? appCtrl.appTheme.whiteColor
                        : appCtrl.appTheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.r8))
                .marginSymmetric(horizontal: Insets.i10, vertical: Insets.i5),
            if (document!.data().toString().contains('emoji'))
              EmojiLayout(emoji: document!["emoji"]),
          ],
        ));
  }
}
