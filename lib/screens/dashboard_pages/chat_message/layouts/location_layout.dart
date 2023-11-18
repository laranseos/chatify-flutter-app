import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';

class LocationLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  final VoidCallback? onLongPress;
  final dynamic document;
  final bool isReceiver, isBroadcast;

  const LocationLayout(
      {Key? key,
      this.onLongPress,
      this.onTap,
      this.document,
      this.isReceiver = false,
      this.isBroadcast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SmoothContainer(
                  margin: const EdgeInsets.symmetric(horizontal: Insets.i8),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.r20),
                    topRight: const Radius.circular(AppRadius.r20),
                    bottomRight: const Radius.circular(AppRadius.r20),
                    bottomLeft: Radius.circular(isReceiver ? 0 : 20),
                  ),
                  color: appCtrl.appTheme.primary,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 15, cornerSmoothing: 1),
                            child: Image.asset(imageAssets.map,
                                height: Sizes.s150))
                      ]).paddingAll(Insets.i5)),
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
          ])).marginSymmetric(horizontal: Insets.i8)
        ]));
  }
}
