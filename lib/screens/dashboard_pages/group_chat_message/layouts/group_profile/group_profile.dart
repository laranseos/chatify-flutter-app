import 'package:chatify_web/screens/dashboard_pages/chat_message/layouts/chat_user_profile/center_position_image.dart';

import '../../../../../config.dart';
import 'group_profile_body.dart';

class GroupProfile extends StatefulWidget {
  const GroupProfile({Key? key}) : super(key: key);

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
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
      topAlign = 5;
    }
    return  GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Stack(alignment: Alignment.bottomCenter, children: [
        Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(svgAssets.closeCircle))
            .paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i30).inkWell(onTap: (){
          chatCtrl.isUserProfile =false;
          chatCtrl.update();
        }),
        const  SingleChildScrollView(child: GroupProfileBody()),
        CenterPositionImage(
            isGroup: true,
            image: chatCtrl.groupImage,
            name: chatCtrl.pName,
            isSliverAppBarExpanded: isSliverAppBarExpanded,
            topAlign: topAlign,onTap:  ()=> chatCtrl.imagePickerOption(context))
      ]) .height(MediaQuery.of(context).size.height)
          .width(Sizes.s450)
          .backgroundColor(appCtrl.appTheme.primary);
    });
  }
}
