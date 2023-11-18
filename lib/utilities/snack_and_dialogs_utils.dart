

import '../config.dart';

snackBar(message, {context, duration, textColor, backgroundColor, icon}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        if (icon != null) SvgPicture.asset(icon!),
        const HSpace(Sizes.s15),
        Text(
          message,
          style: AppCss.poppinsSemiBold14.textColor(textColor),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
    dismissDirection: DismissDirection.horizontal,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.r15),
    ),
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).size.height - Sizes.s80,
        right: Insets.i15,
        left: MediaQuery.of(Get.context!).size.width * Sizes.s30 / Sizes.s100),
  );

  ScaffoldMessenger.of(context ?? Get.context).clearSnackBars();
  ScaffoldMessenger.of(context ?? Get.context).showSnackBar(snackBar);

  //ex : helper.snackBar('alert message');
}

snackBarWithAction(message, context) {
  final snackBar = SnackBar(
    content: const Text('Yay! A SnackBar!'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  //ex : helper.snackBar('alert message');
}

dialogMessage(
  String message, {
  String title = "Multikart",
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  return Get.defaultDialog(
    title: title,
    middleText: message,
    onConfirm: onConfirm,
    titleStyle: AppCss.poppinsSemiBold16,
    middleTextStyle: AppCss.poppinsRegular12,
    confirmTextColor: appCtrl.appTheme.whiteColor,
    //buttonColor: appColor.primary,
    onCancel: onCancel,
    barrierDismissible: barrierDismissible,
  );

  //ex : helper.dialogMessage('dialog message', (){});
}

appUpdateDialog(
  String message, {
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  bool forceUpdate = false,
}) {
  return Get.defaultDialog(
    title: trans('App Update'),
    middleText: message,
    titleStyle: AppCss.poppinsSemiBold16,
    barrierDismissible: !forceUpdate,
    middleTextStyle: AppCss.poppinsRegular12,
    contentPadding:
        const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
    titlePadding: const EdgeInsets.only(top: 15),
    onWillPop: forceUpdate == true ? () async => false : null,
    actions: [
      if (!forceUpdate)
        ElevatedButton(
          onPressed: onCancel,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(appCtrl.appTheme.whiteColor),
            elevation: MaterialStateProperty.resolveWith<double>(
              // As you said you dont need elevation. I'm returning 0 in both case
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return 0;
                }
                return 0; // Defer to the widget's default.
              },
            ),
          ),
          child: Text(
            trans('cancel'),
            style: AppCss.poppinsSemiBold16.copyWith(color: appCtrl.appTheme.grey),
          ),
        ),
      ElevatedButton(
        onPressed: onConfirm,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(appCtrl.appTheme.whiteColor),
          elevation: MaterialStateProperty.resolveWith<double>(
            // As you said you don't need elevation. I'm returning 0 in both case
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return 0;
              }
              return 0; // Defer to the widget's default.
            },
          ),
        ),
        child: Text(
          trans('update'),
          style: AppCss.poppinsSemiBold16,
        ),
      ),
    ],
  );
}

deleteConfirmation(
    {context, title, message, onConfirm, bool barrierDismissible = true}) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(trans('cancel'), style: AppCss.poppinsRegular12),
    onPressed: () {
      Get.back();
    },
  );
  Widget continueButton = TextButton(
    onPressed: onConfirm,
    child: Text(trans('continue')),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title ?? trans('delete_confirmation'),
        style: AppCss.poppinsSemiBold16),
    content: Text(message ?? trans('are_you_sure_delete'),
        style: AppCss.poppinsRegular12),
    actions: [cancelButton, continueButton],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

sendOtp() async {
  Get.generalDialog(
    pageBuilder: (context, anim1, anim2) {
      return Align(
          alignment: Alignment.center,
          child: Container(
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: Insets.i10),
              child: Container()));
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(anim1),
          child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

//show error message
showToast(error) {
  Fluttertoast.showToast(msg: error);
}

//unblock confirmation
unblockConfirmation(pName, value, chatId, pId) async {
  Get.generalDialog(
    pageBuilder: (context, anim1, anim2) {
      return Align(
          alignment: Alignment.center,
          child: AlertDialog(
              content: Text(fonts.unblockUser(pName)),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(fonts.cancel.tr,
                        style: AppCss.poppinsMedium16
                            .textColor(appCtrl.appTheme.grey))),
                TextButton(
                    onPressed: () async {

                    },
                    child: Text(fonts.unblock.tr,
                        style: AppCss.poppinsMedium16
                            .textColor(appCtrl.appTheme.primary)))
              ]));
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );

}


snackBarMessengers({message, color}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message.toString().tr,
          style: AppCss.poppinsMedium16.textColor(appCtrl.appTheme.white)),
      backgroundColor: color ?? appCtrl.appTheme.error));
}

accessDenied(String content, {GestureTapCallback? onTap}) {
  Get.dialog(
    AlertDialog(
      title: Text(fonts.report.tr),
      content: Text(content.tr),
      actions: <Widget>[
        CommonButton(
          title: fonts.close.tr,
          width: Sizes.s80,
          style: AppCss.poppinsMedium16.textColor(appCtrl.appTheme.white),
          onTap: () => Get.back(),
        ),
        CommonButton(
          title: fonts.yes.tr,
          width: Sizes.s80,
          style: AppCss.poppinsMedium16.textColor(appCtrl.appTheme.white),
          onTap: onTap,
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
