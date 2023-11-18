import '../../../../config.dart';

class CommonLoader extends StatelessWidget {
  final bool isLoading;
  const CommonLoader({Key? key,this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (appCtrl) {
        return Positioned(
          child: isLoading
              ? Container(
height: MediaQuery.of(context).size.height,
            color: appCtrl.appTheme.blackColor.withOpacity(.3),
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
