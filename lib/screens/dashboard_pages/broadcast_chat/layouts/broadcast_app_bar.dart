import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';

class BroadCastAppBar extends StatelessWidget {
  final String? name, nameList;

  const BroadCastAppBar({Key? key, this.name, this.nameList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      String name = chatCtrl.broadData["users"] != null
          ? "${chatCtrl.broadData["users"].length} recipients"
          : "0";
      return Column(
          children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SmoothContainer(
                height: Sizes.s60,
                width: Sizes.s60,
                alignment: Alignment.center,
                color: const Color(0xff3282B8),
                smoothness: 0.9,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                child: Text(
                  name.length > 2
                      ? name
                      .replaceAll(" ", "")
                      .substring(0, 2)
                      .toUpperCase()
                      : name[0],
                  style: AppCss.poppinsblack16
                      .textColor(appCtrl.appTheme.white),
                )),
            const HSpace(Sizes.s8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: AppCss.poppinsBold16
                    .textColor(appCtrl.appTheme.blackColor),
              ),
              const VSpace(Sizes.s10),
              Text(
                chatCtrl.nameList,
                style: AppCss.poppinsMedium14
                    .textColor(appCtrl.appTheme.blackColor),
              )
            ]),
          ],
        ),
        Stack(alignment: Alignment.center, children: [
          SmoothContainer(
            width: Sizes.s40,
            height: Sizes.s40,
            borderRadius: BorderRadius.circular(AppRadius.r12),

            foregroundDecoration: BoxDecoration(
                color: appCtrl.appTheme.white,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Color.fromRGBO(0, 0, 0, 0.08))
                ]),
          ),
          PopupMenuButton(
              color: appCtrl.appTheme.whiteColor,
              icon: SvgPicture.asset(
                svgAssets.moreVertical,
                colorFilter: ColorFilter.mode(
                    appCtrl.appTheme.blackColor, BlendMode.srcIn),
              ),
              onSelected: (result) {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              itemBuilder: (ctx) =>
              [
                _buildPopupMenuItem("Search", svgAssets.search, 2),
                _buildPopupMenuItem(
                    "Exit Group", svgAssets.logout, 3),
                _buildPopupMenuItem("Clear Chat", svgAssets.trash, 4),
              ])
        ])
      ]).marginSymmetric(horizontal: Insets.i40, vertical: Insets.i30),
      Divider(
      color: appCtrl.appTheme.dividerColor,
      height: 0,
      thickness: 1).marginSymmetric(horizontal: Insets.i30)
      ],
      );
    });
  }

  PopupMenuItem _buildPopupMenuItem(String title, String iconData,
      int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          SvgPicture.asset(iconData),
          const HSpace(Sizes.s5),
          Text(
            title,
            style:
            AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor),
          ),
        ],
      ),
    );
  }
}
