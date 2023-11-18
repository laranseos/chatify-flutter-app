import 'dart:developer';

import '../../../../config.dart';


class CurrentUserEmptyStatus extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? currentUserId;

  const CurrentUserEmptyStatus({Key? key, this.onTap, this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return appCtrl.user != null
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(collectionName.users)
                .where("id", isEqualTo: appCtrl.user["id"])
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  log("SATATUSSS ${snapshot.data!.docs}");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(children: [
                        CommonImage(
                          height: Sizes.s55,
                          width: Sizes.s55,
                          image: (snapshot.data!).docs[0]["image"] ,
                          name: (snapshot.data!).docs[0]["name"],
                        ),

                      ]).width(Sizes.s55),
                      const VSpace(Sizes.s5),
                      Text((snapshot.data!).docs[0]["name"],
                          overflow: TextOverflow.ellipsis,
                          style: AppCss.poppinsMedium12
                              .textColor(appCtrl.appTheme.blackColor))
                    ],
                  ).inkWell(onTap: onTap);
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            })
        : Container();
  }
}
