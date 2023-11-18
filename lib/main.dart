import 'dart:developer';
import 'dart:ui';
import 'package:chatify_web/screens/auth_screens/login_screen.dart';
import 'package:chatify_web/screens/dashboard_pages/index/index.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'package:universal_html/html.dart' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
  // See related issue: https://github.com/flutter/flutter/issues/96391
  GetStorage.init();
  Get.put(AppController());

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "Your Firebase API Key",
        authDomain: "Your Auth Domain",
        projectId: "Your Firebase ProjectId",
        storageBucket: "Your Storage Bucket",
        messagingSenderId: "Your Messaging Sender Id",
        appId: "Your Firebase APP Id",
        measurementId: "Your Measurement Id"),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "key2");

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    html.window.onBeforeUnload.listen((event) async {
      log("EVENT ${appCtrl.user["id"]}");
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.userContact)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.asMap().entries.forEach((element) {
            element.value.reference.delete();
          });
        }
      });
    });
    appCtrl.isLogin = html.window.localStorage[session.isLogin] ?? "false";
    log("ISLOGIN : ${appCtrl.isLogin}");
    appCtrl.user = appCtrl.storage.read(session.user) ?? "";
    appCtrl.update();
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: fonts.appName.tr,
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            appCtrl.pref = snapData.data;
            appCtrl.update();

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
              ],
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                translations: Language(),
                locale: const Locale('en', 'US'),
                fallbackLocale: const Locale('en', 'US'),
                // tran
                title: fonts.appName.tr,
                home: appCtrl.isLogin == "true"
                    ? Title(
                        title: fonts.appName.tr,
                        color: appCtrl.appTheme.blackColor,
                        child: IndexLayout(
                          pref: snapData.data,
                        ))
                    : LoginScreen(
                        pref: snapData.data,
                      ),
                getPages: appRoute.getPages,
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeService().theme,
                scrollBehavior: MyCustomScrollBehavior(),
              ),
            );
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
              ],
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                translations: Language(),
                locale: const Locale('en', 'US'),
                fallbackLocale: const Locale('en', 'US'),
                // tran
                title: fonts.appName.tr,
                home: Center(
                    child: Image.asset(
                  imageAssets.splashIcon,
                  // replace your Splashscreen icon
                  width: Sizes.s210,
                )),
                getPages: appRoute.getPages,
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeService().theme,
                scrollBehavior: MyCustomScrollBehavior(),
              ),
            );
          }
        });
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
