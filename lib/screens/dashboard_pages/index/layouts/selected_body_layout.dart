import 'package:chatify_web/screens/dashboard_pages/broadcast_chat/broadcast_chat.dart';
import 'package:chatify_web/screens/dashboard_pages/chat_message/chat_message.dart';
import 'package:chatify_web/screens/dashboard_pages/group_chat_message/group_chat_message.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class SelectedIndexBodyLayout extends StatelessWidget {
  const SelectedIndexBodyLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return Consumer<FetchContactController>(
          builder: (context1, registerAvailableContact, child) {
          return Expanded(
              child: SelectionArea(
                  child: CustomScrollView(
                      shrinkWrap: true,
                      controller: indexCtrl.scrollController,
                      slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  AnimatedContainer(
                      height: MediaQuery.of(context).size.height,
                      duration: const Duration(seconds: 2),
                      color: appCtrl.appTheme.bgColor,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            indexCtrl.chatId != null
                                ? indexCtrl.chatType == 0
                                    ? const Chat()
                                    : indexCtrl.chatType == 1
                                        ? const GroupChatMessage()
                                        : const BroadcastChat()
                                :  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [

                                        Image.asset(gifAssets.message,
                                            height: Sizes.s280),
                                        const VSpace(Sizes.s35),
                                      registerAvailableContact.alreadyRegisterUser.isEmpty ?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('New Register?',
                                              style: AppCss.poppinsSemiBold20
                                                  .textColor(appCtrl.appTheme.txt)),
                                          const VSpace(Sizes.s15),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Sync Your contact from app. For that Download the app and login in to your account.\nNow go to ",
                                                  style:    AppCss.poppinsMedium14
                                                      .textColor(appCtrl.appTheme.txt).textHeight(1.2)
                                                ),
                                                const WidgetSpan(
                                                  child: Icon(Icons.settings, size: 20),
                                                ),
                                                TextSpan(
                                                  text: " Setting in that click on ", style:    AppCss.poppinsMedium14
                                                    .textColor(appCtrl.appTheme.txt).textHeight(1.2)
                                                ),
                                                const WidgetSpan(
                                                  child: Icon(Icons.sync, size: 20),
                                                ),
                                                TextSpan(
                                                  text: " Sync now text button.",   style:    AppCss.poppinsMedium14
                                                    .textColor(appCtrl.appTheme.txt).textHeight(1.2)
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ):
                                        Text("You’ve not chat yet !!",
                                            style: AppCss.poppinsSemiBold20
                                                .textColor(
                                                    appCtrl.appTheme.blackColor))
                                      ]).marginOnly(
                                    top: MediaQuery.of(context).size.height / 5)
                          ]))
                ])),
                SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: const Column(
                            children: <Widget>[Expanded(child: SizedBox.shrink())])
                        .backgroundColor(appCtrl.appTheme.bgColor))
              ])));
        }
      );
    });
  }

}
