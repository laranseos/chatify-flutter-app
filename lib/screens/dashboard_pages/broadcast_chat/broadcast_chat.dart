
import '../../../config.dart';

class BroadcastChat extends StatefulWidget {
  const BroadcastChat({Key? key}) : super(key: key);

  @override
  State<BroadcastChat> createState() => _BroadcastChatState();
}

class _BroadcastChatState extends State<BroadcastChat>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final chatCtrl = Get.put(BroadcastChatController());
  dynamic receiverData;

  @override
  void initState() {
    // TODO: implement initState
    receiverData = Get.arguments;
    WidgetsBinding.instance.addObserver(this);
    setState(() {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
    } else {
      firebaseCtrl.setLastSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (_) {
      return WillPopScope(
          onWillPop: chatCtrl.onBackPress,
          child: Stack(children: <Widget>[
            const BroadcastBody(),
            // Loading
            if (chatCtrl.isLoading!)
              CommonLoader(isLoading: chatCtrl.isLoading!)
          ]));
    });
  }
}
