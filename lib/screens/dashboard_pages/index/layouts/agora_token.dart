import 'dart:developer';

import 'package:chatify_web/config.dart';

class AgoraToken extends StatelessWidget {
  final Widget? scaffold;
  const AgoraToken({Key? key,this.scaffold}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = appCtrl.storage.read(session.user);
    return user != null && user != ""
        ? StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName.config)
          .doc(session.agoraToken)
          .snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data!.data()!.isNotEmpty){
          appCtrl.storage.write(session.agoraToken, snapshot.data!.data());
          log("token con : ${snapshot.data!.data()}");
        }
        return scaffold!;

      },
    )
        : scaffold!;
  }
}
