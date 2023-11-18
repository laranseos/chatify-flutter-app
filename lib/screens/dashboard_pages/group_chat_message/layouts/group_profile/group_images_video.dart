

import '../../../../../config.dart';
import '../../../chat_message/layouts/chat_user_profile/chat_video.dart';


class GroupImagesVideos extends StatelessWidget {
  final String? chatId;
  const GroupImagesVideos({Key? key,this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName.groupMessage)
          .doc(chatId)
          .collection(collectionName.chat)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List messages = [];
          if (snapshot.data!.docs.isNotEmpty) {
            snapshot.data!.docs.asMap().entries.forEach((e) {
              if (e.value.data()["type"] == MessageType.image.name ||
                  e.value.data()["type"] == MessageType.video.name) {
                messages.add(e.value.data());
              }
            });
          }
          return messages.isNotEmpty ? Container(
              margin: const EdgeInsets.all(Insets.i20),
              padding: const EdgeInsets.all(Insets.i15),
              decoration: ShapeDecoration(
                  color: appCtrl.appTheme.whiteColor,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 20, cornerSmoothing: 1),
                  ),
                  shadows:const [
                     BoxShadow(
                        color: Color.fromRGBO(49, 100, 189, 0.08),
                        spreadRadius: 2,
                        blurRadius: 12)
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Text(
                         fonts.mediaDocLinks.tr,
                          style: AppCss.poppinsSemiBold14
                              .textColor(appCtrl.appTheme.blackColor),
                        )
                      ],
                    ),
                    const VSpace(Sizes.s15),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...messages.asMap().entries.map((e) {
                                return e.value["type"] == MessageType.image.name
                                    ? CommonImage(
                                        height: Sizes.s74,
                                        width: Sizes.s74,
                                        image:
                                            decryptMessage(e.value["content"]),
                                        name: "C").marginOnly(right: Insets.i10)
                                    : ChatVideo(
                                        snapshot:
                                            decryptMessage(e.value["content"])).marginOnly(right: Insets.i10);
                              }).toList()
                            ]))
                  ])) :Container();
        } else {
          return Container();
        }
      },
    );
  }
}
