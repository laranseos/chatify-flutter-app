import '../../../../config.dart';

class GroupBuildLoader extends StatelessWidget {
  const GroupBuildLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(
        builder: (chatCtrl) {
          return Positioned(
            child: chatCtrl.isLoading
                ? Container(
              color: appCtrl.appTheme.whiteColor.withOpacity(0.8),
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        appCtrl.appTheme.primary)),
              ),
            )
                : Container(),
          );
        }
    );
  }
}
