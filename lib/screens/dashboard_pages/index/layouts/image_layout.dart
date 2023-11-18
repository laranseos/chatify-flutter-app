
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';

class ImageLayout extends StatelessWidget {
  final String? id;
  final bool isLastSeen,isImageLayout ;

  const ImageLayout({Key? key, this.id, this.isLastSeen = true,this.isImageLayout = false })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("id", isEqualTo: id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (!snapshot.data!.docs.isNotEmpty) {
              return Stack(
                children: [
                  SmoothContainer(
                      height: isImageLayout? Sizes.s60: Sizes.s40,
                      width: isImageLayout? Sizes.s60:   Sizes.s40,
                      smoothness: 0.9,
                      color: appCtrl.appTheme.grey.withOpacity(.4),
                      borderRadius: BorderRadius.circular(12),
                      alignment: Alignment.center,
                      child: Image.asset(
                        imageAssets.user,
                        height: isImageLayout? Sizes.s60:  Sizes.s40,
                        width: isImageLayout? Sizes.s60: Sizes.s40,
                        color: appCtrl.appTheme.whiteColor,
                      ).paddingAll(Insets.i15)),
                  if (isLastSeen)
                    if (snapshot.data!.docs[0].data()["status"] == 'Online')
                      Positioned(
                        right: 3,
                        bottom: 10,
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.circle,
                                    color: appCtrl.appTheme.greenColor,
                                    size: Sizes.s12)
                                .paddingAll(Insets.i2)
                                .decorated(
                                    color: appCtrl.appTheme.whiteColor,
                                    shape: BoxShape.circle)),
                      )
                ],
              );
            } else {
              return Stack(
                children: [
                  CommonImage(
                      height: isImageLayout? Sizes.s60:  Sizes.s40,
                      width: isImageLayout? Sizes.s60: Sizes.s40,
                      image: (snapshot.data!).docs[0]["image"],
                      name: (snapshot.data!).docs[0]["name"]),
                  if (isLastSeen)
                    if (snapshot.data!.docs[0].data()["status"] == 'Online')
                    Positioned(
                      right: -2,
                      bottom: 0,
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(Icons.circle,
                                  color: appCtrl.appTheme.greenColor,
                                  size: Sizes.s12)
                              .paddingAll(Insets.i2)
                              .decorated(
                                  color: appCtrl.appTheme.whiteColor,
                                  shape: BoxShape.circle)),
                    )
                ],
              );
            }
          } else {
            return SmoothContainer(
                height:  isImageLayout? Sizes.s60: Sizes.s40,
                width: isImageLayout? Sizes.s60: Sizes.s40,
                smoothness: 0.9,
                color: appCtrl.appTheme.grey.withOpacity(.4),
                borderRadius: BorderRadius.circular(12),
                alignment: Alignment.center,
                child: Image.asset(
                  imageAssets.user,
                  height:  isImageLayout? Sizes.s60: Sizes.s40,
                  width: isImageLayout? Sizes.s60: Sizes.s40,
                  color: appCtrl.appTheme.whiteColor,
                ).paddingAll(Insets.i15));
          }
        });
  }
}
