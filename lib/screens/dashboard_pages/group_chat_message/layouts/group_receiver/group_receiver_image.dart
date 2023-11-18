import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../../config.dart';

class GroupReceiverImage extends StatelessWidget {
  final DocumentSnapshot? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;

  const GroupReceiverImage(
      {Key? key, this.document, this.onLongPress, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("RECEIVER : ${document!['content']}");
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              decoration: ShapeDecoration(
                color: appCtrl.appTheme.chatSecondaryColor,
                shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        topLeft:
                            SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                        topRight:
                            SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                        bottomRight: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 1))),
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(document!['senderName'],
                        style: AppCss.poppinsSemiBold12
                            .textColor(appCtrl.appTheme.txtColor))
                    .paddingOnly(
                        left: Insets.i12,
                        right: Insets.i12,
                        top: Insets.i12,
                        bottom: Insets.i10),
                ClipSmoothRect(
                    clipBehavior: Clip.hardEdge,
                    radius: SmoothBorderRadius(
                        cornerRadius: 20, cornerSmoothing: 1),
                    child: Material(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 20, cornerSmoothing: 1),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                    width: Sizes.s160,
                                    height: Sizes.s150,
                                    decoration: BoxDecoration(
                                      color: appCtrl.appTheme.accent,
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.r8),
                                    ),
                                    child: Container()),
                                imageUrl: decryptMessage(document!['content']),
                                width: Sizes.s160,
                                height: Sizes.s150,
                                fit: BoxFit.cover))
                        .paddingSymmetric(horizontal: Insets.i10)
                        .paddingOnly(bottom: Insets.i12))
              ])),
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
              .marginSymmetric(horizontal: Insets.i5, vertical: Insets.i8)
        ],
      ),
    );
  }
}
