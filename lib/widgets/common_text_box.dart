import '../../../../config.dart';

class CommonTextBox extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hinText;
  final String labelText;
  final InputBorder? border;
  final Color? fillColor;
  final FormFieldValidator<String>? validator;
  final bool filled;
  final bool obscureText;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onFieldSubmitted;
  final String? errorText;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final String counterText;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const CommonTextBox(
      {Key? key,
      this.controller,
      this.suffixIcon,
      this.prefixIcon,
      this.border,
      this.hinText = "",
      this.labelText = "",
      this.counterText = "",
      this.fillColor,
      this.validator,
      this.focusNode,
      this.errorText,
      this.obscureText = false,
      this.readOnly = false,
      this.keyboardType,
      this.textInputAction,
      this.maxLength,
      this.onTap,
      this.onFieldSubmitted,
      this.onChanged,
      this.filled = false,this.contentPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder inputBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: appCtrl.appTheme.blackColor));
    return GetBuilder<AppController>(builder: (appCtrl) {
      return TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          readOnly: readOnly,
          style: AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor),
          maxLength: maxLength,
          decoration: InputDecoration(
              filled: filled,
              fillColor: fillColor,
              hintText: trans(hinText),
              labelText: trans(labelText),
              errorText: errorText,
              counterText: "",
              hintStyle:
                  AppCss.poppinsMedium14.textColor(appCtrl.appTheme.txtColor),
              labelStyle:
                  AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor),
              border: border ?? inputBorder,
              focusedBorder: border ?? inputBorder,
              disabledBorder: border ?? inputBorder,
              enabledBorder: border ?? inputBorder,

              contentPadding: contentPadding??
                  const EdgeInsets.fromLTRB(Insets.i20, 0.0, Insets.i20, 0.0),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon));
    });
  }
}
