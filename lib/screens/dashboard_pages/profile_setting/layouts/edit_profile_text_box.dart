

import '../../../../config.dart';

class EditProfileTextBox extends StatelessWidget {
  const EditProfileTextBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(builder: (editCtrl) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const VSpace(Sizes.s20),
        Text(
          "User Name",
          style: AppCss.poppinsMedium15.textColor(appCtrl.appTheme.blackColor),
        ),
        const VSpace(Sizes.s8),
        NameTextBox(
            nameFocus: editCtrl.nameFocus,
            nameText: editCtrl.nameText,
            nameValidation: editCtrl.nameValidation),
        const VSpace(Sizes.s28),
        //email text box
        Text(
          "Email",
          style: AppCss.poppinsMedium15.textColor(appCtrl.appTheme.blackColor),
        ),
        const VSpace(Sizes.s8),
        EmailTextBox(
            emailText: editCtrl.emailText,
            emailValidate: editCtrl.emailValidate,
            focusNode: editCtrl.emailFocus,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: appCtrl.appTheme.primary))),
        const VSpace(Sizes.s28),
        Text(
          "Mobile Number",
          style: AppCss.poppinsMedium15.textColor(appCtrl.appTheme.blackColor),
        ),
        const VSpace(Sizes.s8),

        CommonTextBox(
            focusNode: editCtrl.phoneFocus,
            controller: editCtrl.phoneText,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(AppRadius.r8)),
            filled: true,
            fillColor: const Color.fromRGBO(153, 158, 166, .1),
            contentPadding: const EdgeInsets.symmetric(horizontal: Insets.i16,vertical: Insets.i16),
            readOnly: editCtrl.phoneText.text.isNotEmpty ? true : false,
            validator: (val) {
              if (val!.isEmpty) {
                return fonts.phoneError.tr;
              } else {
                return null;
              }
            },
            maxLength: 10),

        const VSpace(Sizes.s28),
        Text("Add Status",
            style:
            AppCss.poppinsMedium15.textColor(appCtrl.appTheme.blackColor)),
        const VSpace(Sizes.s8),
        CommonTextBox(
            focusNode: editCtrl.statusFocus,
            controller: editCtrl.statusText,
            textInputAction: TextInputAction.done,
            maxLength: 130,
            contentPadding: const EdgeInsets.symmetric(horizontal: Insets.i16,vertical: Insets.i1),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(AppRadius.r8)),
            filled: true,
            fillColor: const Color.fromRGBO(153, 158, 166, .1),
            keyboardType: TextInputType.multiline,
            errorText: editCtrl.statusValidation ? fonts.phoneError.tr : null),
        const VSpace(Sizes.s45)
      ]);
    });
  }
}
