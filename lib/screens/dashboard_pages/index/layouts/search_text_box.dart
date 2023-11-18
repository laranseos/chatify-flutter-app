import '../../../../config.dart';

class SearchTextBox extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchTextBox({Key? key, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextBox(
      filled: true,
      controller: controller,
      onChanged: onChanged,
      fillColor: appCtrl.appTheme.txtColor.withOpacity(.10),
      labelText: "Search",
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      suffixIcon: SvgPicture.asset(svgAssets.search,
              height: Sizes.s20,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(appCtrl.appTheme.txtColor, BlendMode.srcIn),)
          .marginSymmetric(horizontal: Insets.i8, vertical: Insets.i10),
    ).marginSymmetric(horizontal: Insets.i40);
  }
}
