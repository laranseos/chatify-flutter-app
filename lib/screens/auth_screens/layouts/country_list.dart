import 'package:country_list_pick/country_list_pick.dart';
import '../../../../config.dart';

class CountryListLayout extends StatelessWidget {
  final Function(CountryCode?)? onChanged;
  final String? dialCode;
  const CountryListLayout({Key? key,this.onChanged,this.dialCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.isMobile(context) ? Sizes.s105: Sizes.s120,
            height: Sizes.s52,
            child: CountryListPick(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text("Select Country",
                        style: AppCss.poppinsSemiBold18
                            .textColor(appCtrl.appTheme.white)),
                    elevation: 0,
                    backgroundColor: appCtrl.appTheme.primary),
                pickerBuilder: (context, CountryCode? countryCode) {
                  return Row(children: [
                    Container(
                        height: Responsive.isMobile(context) ?Sizes.s20 :Sizes.s25,
                        width: Responsive.isMobile(context) ?Sizes.s20 :Sizes.s25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill  ,
                                image: AssetImage(
                              countryCode!.flagUri.toString(),
                              package: 'country_list_pick',
                            )),
                            shape: BoxShape.circle)),
                    const HSpace(Sizes.s3),
                    Expanded(
                      child: Text("( ${countryCode.dialCode.toString()} )",
                              overflow: TextOverflow.ellipsis,
                              style: AppCss.poppinsMedium13
                                  .textColor(appCtrl.appTheme.txt)),
                    ),
                    const HSpace(Sizes.s12),
                    SvgPicture.asset(
                      svgAssets.arrowDown,
                      height:Responsive.isMobile(context) ?Sizes.s5 : Sizes.s8
                    )
                  ]);
                },
                theme: CountryTheme(
                    alphabetSelectedBackgroundColor: appCtrl.appTheme.primary),
                initialSelection: dialCode,
                onChanged: onChanged))
        .decorated(
            color: appCtrl.appTheme.txtColor.withOpacity(.10),
            borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)));
  }
}
