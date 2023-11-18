import '../../../../config.dart';

class ContactListTile extends StatelessWidget {
  final DocumentSnapshot? document;
  final bool isReceiver;

  const ContactListTile({Key? key, this.document, this.isReceiver = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CachedNetworkImage(
            imageUrl: decryptMessage(document!['content']).split('-BREAK-')[2],
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: isReceiver?appCtrl.appTheme.txtColor : appCtrl.appTheme.contactBgGray,
              radius: AppRadius.r15,
              backgroundImage: NetworkImage(
                  decryptMessage(document!['content']).split('-BREAK-')[2]),
            ),
            placeholder: (context, url) => CircleAvatar(
                backgroundColor: isReceiver?appCtrl.appTheme.txtColor : appCtrl.appTheme.contactBgGray,
                radius: AppRadius.r15,
                child: Icon(Icons.people, color: appCtrl.appTheme.contactGray)),
            errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: isReceiver?appCtrl.appTheme.txtColor : appCtrl.appTheme.contactBgGray,
                radius: AppRadius.r15,
                child:
                Icon(Icons.people, color: appCtrl.appTheme.contactGray))),
        const HSpace(Sizes.s10),
        Text(decryptMessage(document!['content']).split('-BREAK-')[0],
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppCss.poppinsblack14.textColor(isReceiver
                ? appCtrl.appTheme.primary
                : appCtrl.appTheme.white))
      ],

    ).paddingSymmetric( horizontal: Insets.i15,vertical: Insets.i10);
  }
}
