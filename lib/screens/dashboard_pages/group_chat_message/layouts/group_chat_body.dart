import 'dart:developer';


import 'package:camera/camera.dart';
import 'package:chatify_web/screens/dashboard_pages/group_chat_message/layouts/group_profile/group_profile.dart';
import 'package:flutter/cupertino.dart';

import '../../../../config.dart';

class GroupChatBody extends StatelessWidget {
  const GroupChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return chatCtrl.isCamera
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                chatCtrl.imageFile != null
                    ? Image.memory(
                        chatCtrl.webImage,
                        height: MediaQuery.of(context).size.height,
                      )
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
                        if (chatCtrl.imageFile != null) {
                          await chatCtrl.uploadCameraImage();
                          chatCtrl.isCamera = false;
                          chatCtrl.update();
                        } else {
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
                      child: Icon(chatCtrl.imageFile != null
                          ? Icons.arrow_forward
                          : Icons.camera_alt),
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
                    child: Column(children: <Widget>[
                  const GroupChatMessageAppBar(),
                  // List of messages
                  const GroupMessageBox(),
                  // Sticker
                  Container(),
                  // Input content
                  const GroupInputBox()
                ]).height(MediaQuery.of(context).size.height).inkWell(
                        onTap: () {
                  chatCtrl.enableReactionPopup = false;
                  chatCtrl.showPopUp = false;
                  chatCtrl.isChatSearch = false;
                  chatCtrl.update();
                })),
                if (chatCtrl.isUserProfile) const GroupProfile()
              ],
            );
    });
  }
}
