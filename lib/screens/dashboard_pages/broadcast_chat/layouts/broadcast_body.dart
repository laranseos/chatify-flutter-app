

import '../../../../config.dart';

class BroadcastBody extends StatelessWidget {
  const BroadcastBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {

      return SingleChildScrollView(
        child: Column(children: <Widget>[
          const BroadCastAppBar(),
          // List of messages
          const BroadcastMessage(),
          // Sticker
          Container(),
          // Input content
          const BroadcastInputBox()
        ]).height(MediaQuery.of(context).size.height),
      );
    });
  }

}
