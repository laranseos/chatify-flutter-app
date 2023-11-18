import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../config.dart';

class MyMessageViewer extends StatefulWidget {
  const MyMessageViewer({Key? key}) : super(key: key);

  @override
  State<MyMessageViewer> createState() => _MyMessageViewerState();
}

class _MyMessageViewerState extends State<MyMessageViewer> {
  String? backgroundImage, message;
  String messageType = MessageType.text.name;
  List user = [];

  @override
  void initState() {
    // TODO: implement initState
    var data = Get.arguments;
    backgroundImage = data["backgroundImage"];
    message = data["message"];
    messageType = data["messageType"];
    user = data["seenBy"] ?? [];
    setState(() {});
    log("data : $data");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("TYPE : $messageType");
    log("TYPE : ${message!.contains(".xlsx") || message!.contains(".xls")}");
    return Scaffold(
      backgroundColor: appCtrl.appTheme.bgColor,
      appBar:  CommonAppBar(
        text: fonts.messageInfo.tr,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          message!.length > 40
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Insets.i12, vertical: Insets.i14),
                  width: Sizes.s280,
                  decoration: ShapeDecoration(
                    color: appCtrl.appTheme.primary,
                    shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.only(
                            topLeft: SmoothRadius(
                                cornerRadius: 20, cornerSmoothing: 1),
                            topRight: SmoothRadius(
                                cornerRadius: 20, cornerSmoothing: 1),
                            bottomLeft: SmoothRadius(
                                cornerRadius: 20, cornerSmoothing: 1))),
                  ),
                  child: message!.contains(".xlsx") || message!.contains(".xls")
                      ? Image.asset(
                          imageAssets.xlsx,
                          height: Sizes.s20,
                        )
                      : messageType == MessageType.doc.name
                          ? SvgPicture.asset(
                              svgAssets.docx,
                              colorFilter: ColorFilter.mode(appCtrl.appTheme.white, BlendMode.srcIn),
                            )
                          : message!.contains(".pdf")
                              ? SvgPicture.asset(svgAssets.pdf,
                                  colorFilter: ColorFilter.mode(appCtrl.appTheme.white, BlendMode.srcIn))
                              : messageType == MessageType.gif.name
                                  ? SvgPicture.asset(svgAssets.pdf,
                                      colorFilter: ColorFilter.mode(appCtrl.appTheme.white, BlendMode.srcIn))
                                  : messageType == MessageType.video.name
                                      ? SvgPicture.asset(svgAssets.video,
                                          colorFilter: ColorFilter.mode(appCtrl.appTheme.white, BlendMode.srcIn))
                                      : messageType == MessageType.audio.name
                                          ? SvgPicture.asset(svgAssets.audio,
                                              colorFilter: ColorFilter.mode(appCtrl.appTheme.white, BlendMode.srcIn))
                                          : messageType ==
                                                  MessageType.image.name
                                              ? SvgPicture.asset(
                                                  svgAssets.gallery,
                                                  colorFilter: ColorFilter.mode(appCtrl.appTheme.white, BlendMode.srcIn))
                                              : Text(message!,
                                                  overflow: TextOverflow.clip,
                                                  style: AppCss.poppinsMedium13
                                                      .textColor(appCtrl
                                                          .appTheme.white)
                                                      .letterSpace(.2)
                                                      .textHeight(1.2)))
              : Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Insets.i12, vertical: Insets.i14),
                  decoration: ShapeDecoration(
                      color: appCtrl.appTheme.primary,
                      shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.only(
                              topLeft: SmoothRadius(
                                  cornerRadius: 20, cornerSmoothing: 1),
                              topRight:
                                  SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                              bottomLeft: SmoothRadius(cornerRadius: 20, cornerSmoothing: 1)))),
                  child: Text(message!, overflow: TextOverflow.clip, style: AppCss.poppinsMedium13.textColor(appCtrl.appTheme.white).letterSpace(.2).textHeight(1.2))),
          const VSpace(Sizes.s10),
          Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Read by",
                  style: AppCss.poppinsMedium14
                      .textColor(appCtrl.appTheme.primary)),
              Icon(Icons.done_all, color: appCtrl.appTheme.primary)
            ]),
            const Divider(),
            ...user.asMap().entries.map((e) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(e.value["userId"])
                    .snapshots(),
                builder: (context, snapshot) {
                  String image = "", name = "";
                  if (snapshot.hasData) {
                    image = snapshot.data!.data()!["image"] ?? "";
                    name = snapshot.data!.data()!["name"] ?? "";
                  }
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                      leading: CommonImage(
                          image: image,
                          height: Sizes.s50,
                          width: Sizes.s50,
                          name: name),
                      title: Text(name),
                      subtitle: Text(DateFormat('HH:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(e.value["date"].toString())))));
                },
              );
            }).toList()
          ]).paddingAll(Insets.i20).decorated(color: appCtrl.appTheme.whiteColor, boxShadow: [
            const BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 1,
                color: Color.fromRGBO(0, 0, 0, 0.05))
          ])
        ],
      )
          .width(MediaQuery.of(context).size.width)
          .paddingSymmetric(horizontal: Insets.i20)
          .decorated(
              color: appCtrl.appTheme.bgColor,
              image: backgroundImage != null && backgroundImage != ""
                  ? DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(backgroundImage!))
                  : null),
    );
  }
}
