import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';

class BroadcastInputBox extends StatelessWidget {
  const BroadcastInputBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      return Row(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              margin:
              const EdgeInsets.fromLTRB(Insets.i20, 0, Insets.i20, Insets.i20),
              height: Sizes.s58,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(49, 100, 189, 0.08),
                        blurRadius: 5,
                        offset: Offset(-5, 5)),
                  ],
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                  border: Border.all(
                      color: const Color.fromRGBO(49, 100, 189, 0.1), width: 1),
                  color: appCtrl.appTheme.whiteColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const HSpace(Sizes.s15),
                  Flexible(
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        style: TextStyle(color: appCtrl.appTheme.txt, fontSize: 15.0),
                        controller: chatCtrl.textEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: fonts.enterYourMessage.tr,
                          hintStyle: TextStyle(color: appCtrl.appTheme.gray),
                        ),
                        enableInteractiveSelection: false,
                        focusNode: chatCtrl.focusNode,
                        keyboardType: TextInputType.text,

                      )),
                  SvgPicture.asset(
                    svgAssets.audio,
                    height: Sizes.s22,
                  ).inkWell(
                      onTap: () => chatCtrl.audioRecording(context, "audio", 0)),
                  SizedBox(
                    height: Sizes.s50,
                    width: Sizes.s50,
                    child: SpeedDial(
                        childMargin: EdgeInsets.zero,
                        elevation: 0,
                        backgroundColor: appCtrl.appTheme.whiteColor,
                        children: [
                          SpeedDialChild(
                              child:
                              const Icon(Icons.insert_photo, color: Colors.white),
                              label: fonts.document.tr,
                              backgroundColor: appCtrl.appTheme.indigoColor,
                              onTap: () => chatCtrl.documentShare()),
                          SpeedDialChild(
                            child: const Icon(Icons.camera, color: Colors.white),
                            label: fonts.camera.tr,
                            backgroundColor: appCtrl.appTheme.tealColor,
                            onTap: () {
                              chatCtrl.getImageFromCamera(context);
                            },
                          ),
                          SpeedDialChild(
                            child: const Icon(Icons.email, color: Colors.white),
                            label: 'Images & Videos',
                            backgroundColor: appCtrl.appTheme.purpleColor,
                            onTap: () {
                              chatCtrl.pickerCtrl
                                  .imagePickerOption(Get.context!);
                            },
                          ),

                        ],
                        child: SvgPicture.asset(svgAssets.gif)),
                  ),
                  InkWell(
                    child:  Icon(Icons.gif_box_outlined, color: appCtrl.appTheme.primary),
                    onTap: () async {
                      GiphyGif? gif = await GiphyGet.getGif(
                        tabColor: appCtrl.appTheme.primary,
                        context: context,

                        apiKey: appCtrl.userAppSettingsVal!.gifAPI!, //YOUR API KEY HERE
                        lang: GiphyLanguage.english,
                      );
                      if (gif != null) {
                        chatCtrl.onSendMessage(
                            gif.images!.original!.url, MessageType.gif);
                      }
                    },
                  ).marginOnly( right: appCtrl.isRTL || appCtrl.languageVal == "ar"
                      ? 0
                      : Insets.i6,
                      left: appCtrl.isRTL || appCtrl.languageVal == "ar"
                          ? Insets.i6
                          : 0),
                ],
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SmoothContainer(
                  width: Sizes.s58,
                  height: Sizes.s58,
                  smoothness: .8,
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                  padding: const EdgeInsets.symmetric(
                      vertical: Insets.i10, horizontal: Insets.i2),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.r10),
                    gradient: RadialGradient(colors: [
                      appCtrl.isTheme? appCtrl.appTheme.primary.withOpacity(.8):   appCtrl.appTheme.lightPrimary,
                      appCtrl.appTheme.primary
                    ]),
                  )),
              SvgPicture.asset(svgAssets.send)
            ],
          ).marginOnly(right:appCtrl.isRTL || appCtrl.languageVal == "ar"
              ?Insets.i10 : Insets.i20) .inkWell(
              onTap: () => chatCtrl.onSendMessage(
                  chatCtrl.textEditingController.text, MessageType.text)),
        ],
      );
    });
  }
}
