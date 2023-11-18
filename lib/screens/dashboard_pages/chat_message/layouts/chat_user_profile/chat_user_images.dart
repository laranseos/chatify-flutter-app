import 'package:smooth_corner/smooth_corner.dart';

import '../../../../../config.dart';
import 'chat_video.dart';

class ChatUserImagesVideos extends StatelessWidget {
  final String? chatId;

  const ChatUserImagesVideos({Key? key, this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName.messages)
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
          return SmoothContainer(
              margin: const EdgeInsets.all(Insets.i20),
              padding: const EdgeInsets.all(Insets.i15),
              color: appCtrl.appTheme.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              foregroundDecoration: BoxDecoration(
                  color: appCtrl.appTheme.whiteColor,
                  backgroundBlendMode: BlendMode.srcIn,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  boxShadow: const [
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
                          "Media, docs and links",
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
                                            image: decryptMessage(
                                                e.value["content"]),
                                            name: "C")
                                        .marginOnly(right: Insets.i10)
                                    : ChatVideo(
                                            snapshot: decryptMessage(
                                                e.value["content"]))
                                        .marginOnly(right: Insets.i10);
                              }).toList()
                            ]))
                  ]));
        } else {
          return Container();
        }
      },
    );
  }
}
