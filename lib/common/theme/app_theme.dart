import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}

class AppTheme {
  static ThemeType defaultTheme = ThemeType.light;

  //Theme Colors
  bool isDark;
  Color txt;
  Color primary;
  Color splashPrimary;
  Color secondary;
  Color accent;
  Color transparentColor;
  Color chatBgColor;
  Color darkRedColor;
  Color lightPrimary;
  Color greenColor;
  Color bgColor;
  Color txtColor;
  Color statusTxtColor;
  Color profileSettingColor;
  Color chatSecondaryColor;

  //Extra Colors
  Color grey;
  Color gray;
  Color darkGray;
  Color white;
  Color whiteColor;
  Color blackColor;
  Color chatAppBarColor;
  Color lightBlackColor;
  Color redColor;
  Color textColor;
  Color bg1;
  Color error;
  Color borderGray;
  Color lightGray;
  Color contactBgGray;
  Color contactGray;
  Color lightDividerColor;
  Color lightGreyColor;
  Color lightGrey1Color;
  Color indigoColor;
  Color pinkColor;
  Color purpleColor;
  Color orangeColor;
  Color tealColor;
  Color blueColor;
  Color emojiShadowColor;
  Color dividerColor;
  Color drawerColor;

  /// Default constructor
  AppTheme({
    required this.isDark,
    required this.txt,
    required this.primary,
    required this.splashPrimary,
    required this.secondary,
    required this.accent,
    required this.darkRedColor,
    required this.lightPrimary,
    required this.greenColor,
    required this.bgColor,
    //Extra
    required this.grey,
    required this.gray,
    required this.darkGray,
    required this.white,
    required this.whiteColor,
    required this.blackColor,
    required this.chatAppBarColor,
    required this.lightBlackColor,
    required this.redColor,
    required this.textColor,
    required this.transparentColor,
    required this.chatBgColor,
    required this.bg1,
    required this.error,
    required this.borderGray,
    required this.lightGray,
    required this.contactBgGray,
    required this.contactGray,
    required this.lightDividerColor,
    required this.lightGreyColor,
    required this.lightGrey1Color,
    required this.indigoColor,
    required this.pinkColor,
    required this.purpleColor,
    required this.orangeColor,
    required this.tealColor,
    required this.blueColor,
    required this.txtColor,
    required this.statusTxtColor,
    required this.profileSettingColor,
    required this.chatSecondaryColor,
    required this.emojiShadowColor,
    required this.dividerColor,
    required this.drawerColor,
  });

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppTheme(
          isDark: false,
          txt: const Color(0xFF000E08),
          primary: const Color(0xFF3164BD),
          lightPrimary: const Color(0xFF4B84E7),
          splashPrimary: Colors.white,
          secondary: const Color(0xFF6EBAE7),
          accent: const Color(0xFF797C7B),
          grey: Colors.grey,
          gray: const Color(0xFFaeaeae),
          darkGray: const Color(0xFFE8E8E8),
          darkRedColor: const Color(0xFFFF4E59),
          white: Colors.white,
          whiteColor: Colors.white,
          textColor: Colors.white,
          transparentColor: Colors.transparent,
          bg1: const Color(0xFFD4DEE5),
          chatBgColor: const Color(0xFFECF1F4),
          error: Colors.red,
          borderGray: const Color(0xFFE6E8EA),
          blackColor: const Color(0xFF010D21),
          chatAppBarColor: Colors.white,
          lightBlackColor: const Color(0xFF586780),
          redColor: Colors.red,
          lightGray: const Color(0xFFF2F2F2),
          contactBgGray: const Color(0xFFE6E6E6),
          contactGray: const Color(0xFFCCCCCC),
          lightDividerColor: const Color(0xFF263238),
          lightGreyColor: const Color(0xFFF5F7FB),
          lightGrey1Color: const Color(0xFFEBF0F8),
          greenColor: Colors.green,
          indigoColor: Colors.indigo,
          pinkColor: Colors.pink,
          purpleColor: Colors.purple,
          orangeColor: Colors.orange,
          tealColor: Colors.teal,
          blueColor: Colors.blue,
          bgColor:const Color(0xFFFDFDFD),
          txtColor:const Color(0xFF999EA6),
          statusTxtColor:const Color(0xFF7A8AA3),
          profileSettingColor:const Color(0xFFF3F4F4),
          chatSecondaryColor:const Color.fromRGBO(153, 158, 166, 0.1),
          emojiShadowColor:const Color.fromRGBO(78, 160, 247, 0.12),
          dividerColor:const Color(0xFFE6EAEF),
          drawerColor:const Color.fromRGBO(49, 100, 189, 0.03),
        );

      case ThemeType.dark:
        return AppTheme(
          isDark: true,
          txt: Colors.white,
          primary: const Color(0xFF3164BD),
          lightPrimary: Colors.black12,
          splashPrimary: const Color(0xFF3467B8),
          secondary: const Color(0xFF6EBAE7),
          accent: const Color(0xFF797C7B),
          grey: Colors.grey,
          gray: const Color(0xFFaeaeae),
          darkGray: const Color(0xFFE8E8E8),
          darkRedColor: const Color(0xFFFF4E59),
          white: Colors.white,
          whiteColor:const Color(0xFF132037),
          blackColor: Colors.white,
          chatAppBarColor: const Color(0xFF010D21),
          lightBlackColor:Colors.white,
          redColor: Colors.red,
          textColor: const Color(0xFF636363),
          bg1: const Color(0xFFD4DEE5),
          chatBgColor: Colors.black,
          error: Colors.red,
          borderGray: const Color(0xFF353C41),
          transparentColor: Colors.transparent,
          lightGray: const Color(0xFFF2F2F2),
          contactBgGray: const Color(0xFFE6E6E6),
          contactGray: const Color(0xFFCCCCCC),
          lightDividerColor: const Color(0xFF263238),
          lightGreyColor: const Color(0xFFF5F7FB),
          lightGrey1Color: const Color(0xFFEBF0F8),
          greenColor: Colors.green,
          indigoColor: Colors.indigo,
          pinkColor: Colors.pink,
          purpleColor: Colors.purple,
          orangeColor: Colors.orange,
          tealColor: Colors.teal,
          blueColor: Colors.blue,
          bgColor: const Color(0xFF010D21),
          txtColor:const Color(0xFF999EA6),
          statusTxtColor:const Color(0xFF7A8AA3),
          profileSettingColor:const Color(0xFFF3F4F4),
          chatSecondaryColor:const Color.fromRGBO(153, 158, 166, 0.1),
          emojiShadowColor:const Color.fromRGBO(78, 160, 247, 0.12),
          dividerColor:const Color(0xFFE6EAEF),
          drawerColor:const Color.fromRGBO(49, 100, 189, 0.03),
        );
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        secondary: secondary,
        background: bg1,
        surface: bg1,

        onSecondary: accent,
        error: error,onBackground: white,
        onSurface: white,
        onError: Colors.red,
        onPrimary: primary,
        tertiary: white,
        onInverseSurface: white,
        tertiaryContainer: white,
        surfaceTint: white,
        surfaceVariant: white,
      ),
    );
    return t.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,useMaterial3: true,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: borderGray,
        selectionHandleColor: Colors.transparent,
        cursorColor: primary,
      ),
      buttonTheme: ButtonThemeData(buttonColor: primary),
      highlightColor: Colors.transparent,
      toggleButtonsTheme: ToggleButtonsThemeData(selectedColor: primary),
    );
  }

//Color shift(Color c, double d) => shiftHsl(c, d * (isDark ? -1 : 1));
}
