import 'dart:developer';

import 'package:chatify_web/screens/dashboard_pages/index/layouts/status_layout.dart';

import '../../../../config.dart';


class CurrentUserStatus extends StatelessWidget {
  final String? currentUserId;

  const CurrentUserStatus({Key? key, this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(builder: (statusCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(currentUserId)
              .collection(collectionName.status)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (!snapshot.data!.docs.isNotEmpty) {
                  return  Container();
                } else {
                  return StatusLayout(
                          snapshot:
                              Status.fromJson(snapshot.data!.docs[0].data()),onTap: (){
                    log("STATYS");
                    final statusCtrl = Get.isRegistered<StatusController>()
                        ? Get.find<StatusController>()
                        : Get.put(StatusController());
                    statusCtrl.openImagePreview(Status.fromJson(snapshot.data!.docs[0].data()));
                  },);
                }
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          });
    });
  }
}
