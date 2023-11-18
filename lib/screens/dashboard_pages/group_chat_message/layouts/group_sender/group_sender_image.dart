

import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../../config.dart';

class GroupSenderImage extends StatelessWidget {
  final DocumentSnapshot? document;
  final VoidCallback? onPressed, onLongPress;

  const GroupSenderImage(
      {Key? key, this.document, this.onPressed, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: onLongPress,
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SmoothContainer(
                    height: Sizes.s150,
                    width: Sizes.s160,
                    smoothness: 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: Insets.i10,),
                    color: appCtrl.appTheme.primary,
                    padding: const EdgeInsets.all(Insets.i15),
                    borderRadius: BorderRadius.circular(12),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                        placeholder: (context, url) => SmoothContainer(
                            height: Sizes.s150,
                            width: Sizes.s160,
                            smoothness: 0.9,
                            color: appCtrl.appTheme.accent,
                            borderRadius: BorderRadius.circular(12),
                            alignment: Alignment.center,
                            child: Container()),
                        imageUrl:
                        decryptMessage(document!['content']),
                        width: Sizes.s160,
                        height: Sizes.s150,
                        fit: BoxFit.cover)),


                if (document!.data().toString().contains('emoji'))
                  EmojiLayout(emoji: document!["emoji"])
              ],
            ),
            const VSpace(Sizes.s2),
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
                        .textColor(appCtrl.appTheme.txtColor),
                  ).marginOnly(right: Insets.i12),
                ]))
          ],
        ));
  }
}
