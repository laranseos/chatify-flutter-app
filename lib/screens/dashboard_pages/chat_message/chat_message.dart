import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:chatify_web/screens/dashboard_pages/chat_message/layouts/chat_app_bar.dart';
import 'package:chatify_web/screens/dashboard_pages/chat_message/layouts/chat_user_profile/chat_user_profile.dart';
import 'package:flutter/cupertino.dart';
import '../../../config.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final chatCtrl = Get.put(ChatController());
  dynamic receiverData;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatCtrl.setTyping();
    });
    receiverData = Get.arguments;

    setState(() {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
      chatCtrl.setTyping();
    } else {
      firebaseCtrl.setLastSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (_) {
      return GetBuilder<IndexController>(builder: (indexCtrl) {
        chatCtrl.onBackPress();
        return WillPopScope(
            onWillPop: chatCtrl.onBackPress,
            child: chatCtrl.allData != null
                ? chatCtrl.isCamera
                ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                chatCtrl.imageFile != null
                    ? Image.memory(chatCtrl.webImage,height: MediaQuery.of(context).size.height)
                    : FutureBuilder<void>(
                    future: chatCtrl.initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.done) {
                        // If the Future is complete, display the preview.
                        return CameraPreview(chatCtrl.cameraController!)
                            .height(MediaQuery.of(context).size.height);
                      } else {
                        // Otherwise, display a loading indicator.
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      // Provide an onPressed callback.
                      onPressed: () async {
                        if(chatCtrl.imageFile != null){
                          await chatCtrl.uploadCameraImage();
                          chatCtrl.isCamera = false;
                          chatCtrl.update();
                        }else {
                          try {
                            final image =
                            await chatCtrl.cameraController!.takePicture();
                            log("CAMERA : $image");
                            chatCtrl.imageFile = image;
                            var imageFile = await image.readAsBytes();
                            chatCtrl.webImage = imageFile;
                            chatCtrl.update();
                          } catch (e) {
                            log(e.toString());
                          }
                        }
                      },
                      child:  Icon( chatCtrl.imageFile !=null ?Icons.arrow_forward : Icons.camera_alt),
                    ).marginOnly(bottom: Insets.i20,right: Insets.i15),
                    FloatingActionButton(
                      // Provide an onPressed callback.
                      onPressed: () async {
                        chatCtrl.isCamera =false;
                        chatCtrl.update();
                        chatCtrl.cameraController!.dispose();
                      },
                      child:const  Icon( CupertinoIcons.multiply),
                    ).marginOnly(bottom: Insets.i20),
                  ],
                )
              ],
            )
                : Row(

                  children: [
                    Expanded(
                      child: Stack(children: <Widget>[
                           Column(children: <Widget>[
                            const ChatAppBar(),
                            // List of messages
                            const MessageBox(),
                            // Sticker
                            Container(),
                            // Input content
                            const InputBox()
                          ]).height(MediaQuery.of(context).size.height).inkWell(
                              onTap: () {
                                chatCtrl.enableReactionPopup = false;
                                chatCtrl.showPopUp = false;
                                chatCtrl.update();
                                log("chatCtrl.enableReactionPopup : ${chatCtrl.enableReactionPopup}");
                              })
                        ,
                          // Loading
                          if (chatCtrl.isLoading)
                            CommonLoader(isLoading: chatCtrl.isLoading),
                          GetBuilder<AppController>(builder: (appCtrl) {
                            return CommonLoader(isLoading: appCtrl.isLoading);
                          })
                        ]),
                    ),
                    if(chatCtrl.isUserProfile)
                     const ChatUserProfile()
                  ],
                )
                : Container());
      });
    });
  }
}
