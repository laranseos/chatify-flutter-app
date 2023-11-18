import '../config.dart';

class EmailTextBox extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? emailText;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? emailValidate;
  final Widget? suffixIcon;
  final InputBorder? border;

  const EmailTextBox(
      {Key? key,
      this.emailText,
      this.focusNode,
      this.emailValidate,
      this.onFieldSubmitted,
      this.suffixIcon,
      this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextBox(
      focusNode: focusNode,
      controller: emailText,
      textInputAction: TextInputAction.next,
      border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppRadius.r8)),
      filled: true,
      fillColor: const Color.fromRGBO(153, 158, 166, .1),
      validator: (val) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (val!.isEmpty) {
          return fonts.emailError.tr;
        } else if (!regex.hasMatch(val)) {
          return fonts.emailValidError.tr;
        } else {
          return null;
        }
      },
      contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.i16, vertical: Insets.i16),
      keyboardType: TextInputType.emailAddress,
      onFieldSubmitted: onFieldSubmitted,
      suffixIcon: suffixIcon,
    );
  }
}
