import 'dart:developer';

import '../../../../config.dart';


class UserLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldDrawerKey;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final IntCallback? onTap;
  const UserLayout({Key? key,this.scaffoldDrawerKey,this.scaffoldKey,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      log("USERRRR ${appCtrl.user}");
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            CommonImage(
                image: appCtrl.user["image"] ??"",
                name: appCtrl.user["name"],
                height: Sizes.s60,
                width: Sizes.s60),
            const HSpace(Sizes.s20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    indexCtrl.user != null ? indexCtrl.user["name"] : "Welcome",
                    style: AppCss.poppinsblack20
                        .textColor(appCtrl.appTheme.blackColor)
                        .letterSpace(.5)),
                const VSpace(Sizes.s8),
                Text(
                  appCtrl.user['statusDesc'],
                  style: AppCss.poppinsLight16
                      .textColor(appCtrl.appTheme.txtColor),
                )
              ],
            )
          ],
        ),
        Container(
            width: Sizes.s40,
            height: Sizes.s40,
            decoration: ShapeDecoration(
                color: appCtrl.appTheme.white,
                shadows:const [
                   BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Color.fromRGBO(0, 0, 0, 0.08))
                ],
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 10, cornerSmoothing: .8))),
            child: PopupMenuButton(
                color: appCtrl.appTheme.whiteColor,


                icon: SvgPicture.asset(
                  svgAssets.moreVertical,
                ),
                onSelected: (result) async{
                 onTap!(result);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                itemBuilder: (ctx) => [
                      _buildPopupMenuItem(fonts.newBroadcast.tr, Icons.search, 0),
                      _buildPopupMenuItem(fonts.newGroup.tr, Icons.upload, 1),
                      _buildPopupMenuItem(fonts.profile.tr, Icons.copy, 2),
                      _buildPopupMenuItem(fonts.setting.tr, Icons.copy, 3),
                      _buildPopupMenuItem(fonts.newChat.tr, Icons.copy, 4),
                      _buildPopupMenuItem(fonts.logout.tr, Icons.copy, 5)
                    ]))
      ]).marginSymmetric(horizontal: Insets.i40, vertical: Insets.i30);
    });
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
height: 0,


      value: position,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: AppCss.poppinsBold16.textColor(appCtrl.appTheme.blackColor)),
          if(position !=5)
            Divider(color: appCtrl.appTheme.dividerColor,height: 0,thickness: 1,).marginSymmetric(vertical: Insets.i20)
        ],
      ).paddingOnly(top: position == 0 ? Insets.i15 : 0,bottom:position == 5 ? Insets.i15 : 0 )
    );
  }
}
