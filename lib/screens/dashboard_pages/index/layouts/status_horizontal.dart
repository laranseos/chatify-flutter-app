import 'dart:developer';

import 'package:chatify_web/screens/dashboard_pages/index/layouts/status_layout.dart';
import '../../../../config.dart';
import 'current_user_status.dart';

class StatusHorizontal extends StatelessWidget {
  const StatusHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (appCtrl) {
        return GetBuilder<IndexController>(builder: (indexCtrl) {

          indexCtrl.user = appCtrl.storage.read(session.user);

          return SizedBox(
            height: Sizes.s76,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (indexCtrl.user != null)
                          CurrentUserStatus(
                            currentUserId: appCtrl.storage.read(session.user)["id"],),
                        ...appCtrl.firebaseContact.asMap().entries.map((e) {
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(collectionName.users)
                                  .doc(e.value.id)
                                  .collection(collectionName.status)
                                  .orderBy("updateAt", descending: true)
                                  .limit(15)
                                  .snapshots(),
                              builder: (context, snapshot) {

                                if (snapshot.hasError) {
                                  return Container();
                                } else if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  List<Status> statusList = [];
                                  List status = indexCtrl.statusListWidget(snapshot);
                                  statusList = [];
                                  status.asMap().entries.forEach((element) {
                                    Status convertStatus = Status.fromJson(element.value);

                                    if (element.value.containsKey("seenAllStatus")) {
                                      if (!convertStatus.seenAllStatus!
                                          .contains(appCtrl.user["id"])) {
                                        if (!statusList.contains(Status.fromJson(element.value))) {
                                          statusList.add(Status.fromJson(element.value));
                                        }
                                      }
                                    } else {
                                      if (!statusList.contains(Status.fromJson(element.value))) {
                                        statusList.add(Status.fromJson(element.value));
                                      }
                                    }

                                  });

                                  return SizedBox(
                                    height: Sizes.s74,
                                    child: ListView.builder(
                                        itemCount: statusList.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                              onTap: () {
                                                log("STAT");
                                                final statusCtrl = Get.isRegistered<StatusController>() ? Get.find<StatusController>():  Get.put(StatusController());
                                                statusCtrl.openImagePreview(statusList[index]);
                                              },
                                              child: StatusLayout(snapshot: statusList[index],).marginOnly(right: Insets.i20));
                                        }),
                                  );
                                }
                              });
                        }).toList()
                    ],
                  ).marginSymmetric(horizontal: Insets.i40),
                ),
                Image.asset(imageAssets.shadow)
              ],
            ),
          );
        });
      }
    );
  }
}
