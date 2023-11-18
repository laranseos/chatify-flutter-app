import '../config.dart';

class PasswordTextBox extends StatelessWidget {
  final TextEditingController? passwordText;
  final bool? passEye, passwordValidation;
  final FocusNode? focusNode;
  final VoidCallback? onPressed;
  final String? labelText;

  const PasswordTextBox(
      {Key? key,
      this.passwordText,
      this.focusNode,
      this.passEye,
      this.onPressed,
      this.labelText,
      this.passwordValidation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextBox(
        controller: passwordText,
        labelText:labelText?? fonts.password.tr,
        obscureText: passEye!,
        focusNode: focusNode,
        textInputAction: TextInputAction.done,
        validator: (val){
          if(val!.isEmpty){
            return fonts.passwordError.tr;
          }else  if(val.length < 8){
            return fonts.passwordLengthError.tr;
          }else{
            return null;
          }
        },
        keyboardType: TextInputType.name,
        suffixIcon: IconButton(
          iconSize: Sizes.s20,
          onPressed: onPressed,
          icon: const Icon(Icons.remove_red_eye),
        ),
    );
  }
}
