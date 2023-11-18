

import 'package:chatify_web/screens/dashboard_pages/chat_message/layouts/chat_user_profile/center_position_image.dart';

import '../../../../../config.dart';
import 'chat_user_profile_body.dart';

class ChatUserProfile extends StatefulWidget {
  const ChatUserProfile({Key? key}) : super(key: key);

  @override
  State<ChatUserProfile> createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends State<ChatUserProfile> {
  var scrollController = ScrollController();
  double topAlign = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
  }

//----------
  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (130 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (isSliverAppBarExpanded) {
      topAlign = topAlign + 1;
    } else {
      topAlign =  Responsive.isMobile(context) ? 4 : Responsive.isTablet(context) ? 4 :  4;
    }
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(svgAssets.closeCircle))
              .paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i30).inkWell(onTap: (){
                chatCtrl.isUserProfile =false;
                chatCtrl.update();
          }),
          const SingleChildScrollView(child: ChatUserProfileBody()),
          CenterPositionImage(
              image: chatCtrl.pData["image"],
              name: chatCtrl.pData["name"],
              isSliverAppBarExpanded: isSliverAppBarExpanded,
              topAlign: topAlign)
        ],
      );
    })
        .height(MediaQuery.of(context).size.height)
        .width(Sizes.s450)
        .backgroundColor(appCtrl.appTheme.primary);
  }
}
