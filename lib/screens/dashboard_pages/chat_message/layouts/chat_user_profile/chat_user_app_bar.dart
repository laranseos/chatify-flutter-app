import 'chat_user_profile_title.dart';
import 'leading_back.dart';
import 'share_button.dart';

import '../../../../../config.dart';


class ChatUserProfileAppBar extends StatelessWidget {

  final bool isSliverAppBarExpanded,isBroadcast;
  final String? image, name;
  const ChatUserProfileAppBar({Key? key,this.isSliverAppBarExpanded =false,this.isBroadcast =false,this.name,this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   SliverAppBar(
      expandedHeight: Sizes.s180,
      elevation: 0,
      floating: true,
      pinned: true,
      stretch: true,
      snap: false,
      automaticallyImplyLeading: false,
      leadingWidth: Sizes.s80,
      titleSpacing: 0,
      toolbarHeight: Sizes.s80,
      backgroundColor: appCtrl.appTheme.primary,
      leading: const LeadingBack(),

      title: ChatUserProfileTitle(
          image: image,

          isBroadcast: isBroadcast,
          isSliverAppBarExpanded: isSliverAppBarExpanded,
          name: name),
      actions: [ShareButton(onTap: () {})],
      centerTitle: !isSliverAppBarExpanded ? true : false,
    );
  }
}
