import '../../../../config.dart';

class NameTextBox extends StatelessWidget {
  final TextEditingController? nameText;
  final FocusNode? nameFocus;
  final bool? nameValidation;
  final ValueChanged<String>? onFieldSubmitted;

  final Widget? suffixIcon;

  const NameTextBox(
      {Key? key,
        this.nameText,
        this.suffixIcon,
        this.nameFocus,
        this.nameValidation,
        this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextBox(
        controller: nameText,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,

        focusNode: nameFocus,
        border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(AppRadius.r8)),
        filled: true,
        fillColor: const Color.fromRGBO(153, 158, 166, .1),
        validator: (val){
          if(val!.isEmpty){
            return fonts.nameError.tr;
          }else {
            return null;
          }
        },
        suffixIcon: suffixIcon,
        errorText: nameValidation! ? fonts.nameError.tr : null,
contentPadding: const EdgeInsets.symmetric(horizontal: Insets.i16,vertical: Insets.i16),
        onFieldSubmitted: onFieldSubmitted);
  }
}