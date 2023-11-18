
import 'dart:developer';

import 'package:chatify_web/screens/dashboard_pages/chat_message/layouts/receiver_image.dart';

import '../../../../../config.dart';
import '../../group_on_tap_function_class.dart';

class GroupReceiverMessage extends StatefulWidget {
  final DocumentSnapshot? document;
  final String? docId;
  final int? index;

  const GroupReceiverMessage({Key? key, this.index, this.document, this.docId})
      : super(key: key);

  @override
  State<GroupReceiverMessage> createState() => _GroupReceiverMessageState();
}

class _GroupReceiverMessageState extends State<GroupReceiverMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            color: chatCtrl.selectedIndexId.contains(widget.docId)
                ? appCtrl.appTheme.primary.withOpacity(.08)
                : appCtrl.appTheme.bgColor,
            margin: const EdgeInsets.only(bottom: Insets.i10),
            padding: const EdgeInsets.only(
                bottom: Insets.i10, left: Insets.i20, right: Insets.i20),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        if (widget.document!["type"] != MessageType.messageType.name)
                        ReceiverChatImage(id: widget.document!["sender"]),
                        const HSpace(Sizes.s8),
                        Column(children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // MESSAGE BOX FOR TEXT
                              if (widget.document!["type"] == MessageType.text.name)
                                GroupReceiverContent(
                                    isSearch:chatCtrl.searchChatId.contains(widget.index) ,
                                    onTap: () => GroupOnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId),
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId),
                                    document: widget.document),

                              // MESSAGE BOX FOR IMAGE
                              if (widget.document!["type"] == MessageType.image.name)
                                GroupReceiverImage(
                                    document: widget.document,
                                    onTap: () => GroupOnTapFunctionCall().imageTap(
                                        chatCtrl, widget.docId, widget.document),
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId)),

                              if (widget.document!["type"] == MessageType.contact.name)
                                GroupContactLayout(
                                    isReceiver: true,
                                    currentUserId: chatCtrl.user["id"],
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId),
                                    document: widget.document),
                              if (widget.document!["type"] == MessageType.location.name)
                                GroupLocationLayout(
                                    isReceiver: true,
                                    document: widget.document,
                                    currentUserId: chatCtrl.user["id"],
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall().locationTap(
                                        chatCtrl, widget.docId, widget.document)),
                              if (widget.document!["type"] == MessageType.video.name)
                                GroupVideoDoc(
                                    isReceiver: true,
                                    currentUserId: chatCtrl.user["id"],
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall().locationTap(
                                        chatCtrl, widget.docId, widget.document)),
                              if (widget.document!["type"] == MessageType.audio.name)
                                GroupAudioDoc(
                                    isReceiver: true,
                                    currentUserId: chatCtrl.user["id"],
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall().locationTap(
                                        chatCtrl, widget.docId, widget.document)),
                              if (widget.document!["type"] == MessageType.doc.name)
                                (decryptMessage(widget.document!["content"]).contains(".pdf"))
                                    ? PdfLayout(
                                        isReceiver: true,
                                        isGroup: true,
                                        document: widget.document,
                                        onLongPress: () =>
                                            chatCtrl.onLongPressFunction(widget.docId),
                                        onTap: () => GroupOnTapFunctionCall().pdfTap(
                                            chatCtrl, widget.docId, widget.document))
                                    : (decryptMessage(widget.document!["content"]).contains(".doc"))
                                        ? DocxLayout(
                                            document: widget.document,
                                            isReceiver: true,
                                            isGroup: true,
                                            onLongPress: () => chatCtrl
                                                .onLongPressFunction(widget.docId),
                                            onTap: () => GroupOnTapFunctionCall()
                                                .docTap(chatCtrl, widget.docId,
                                                    widget.document))
                                        : (decryptMessage(widget.document!["content"])
                                                .contains(".xlsx"))
                                            ? ExcelLayout(
                                                currentUserId: chatCtrl.user["id"],
                                                isReceiver: true,
                                                isGroup: true,
                                                onLongPress: () => chatCtrl
                                                    .onLongPressFunction(widget.docId),
                                                onTap: () => GroupOnTapFunctionCall()
                                                    .excelTap(chatCtrl, widget.docId,
                                                        widget.document),
                                                document: widget.document,
                                              )
                                            : (decryptMessage(widget.document!["content"]).contains(".jpg") ||
                                                    decryptMessage(widget.document!["content"])
                                                        .contains(".png") ||
                                                    decryptMessage(widget.document!["content"])
                                                        .contains(".heic") ||
                                                    decryptMessage(widget.document!["content"])
                                                        .contains(".jpeg"))
                                                ? DocImageLayout(
                                                    currentUserId: chatCtrl.user["id"],
                                                    isGroup: true,
                                                    isReceiver: true,
                                                    document: widget.document,
                                                    onLongPress: () => chatCtrl.onLongPressFunction(widget.docId),
                                                    onTap: () => GroupOnTapFunctionCall().docImageTap(chatCtrl, widget.docId, widget.document))
                                                : Container(),

                              if (widget.document!["type"] == MessageType.gif.name)
                                GifLayout(
                                    currentUserId: chatCtrl.user["id"],
                                    isGroup: true,
                                    isReceiver: true,
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId))
                            ],
                          ),

                        ]),
                      ],
                    ),
                    if (chatCtrl.isHover == true &&
                        chatCtrl.isSelectedHover == widget.index)
                      Row(
                        children: [
                          Icon(Icons.emoji_emotions,color: appCtrl.appTheme.whiteColor,size: Sizes.s15,).paddingAll(Insets.i2).decorated(
                              shape: BoxShape.circle,
                              color: appCtrl.appTheme.grey.withOpacity(.5)).inkWell(onTap: (){
                            chatCtrl.showPopUp = true;
                            chatCtrl.enableReactionPopup = true;

                            if (!chatCtrl.selectedIndexId.contains(widget.docId)) {
                              if (chatCtrl.showPopUp == false) {
                                chatCtrl.selectedIndexId.add(widget.docId);
                              } else {
                                chatCtrl.selectedIndexId = [];
                                chatCtrl.selectedIndexId.add(widget.docId);
                              }
                              chatCtrl. update();
                            }
                            chatCtrl. update();
                          }),
                          const HSpace(Sizes.s5),
                          PopupMenuButton(
                              color: appCtrl.appTheme.whiteColor,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: appCtrl.appTheme.blackColor
                                    .withOpacity(.5),
                              ),
                              onSelected: (result) async {
                                log("result ; R$result");
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(AppRadius.r8),
                              ),
                              itemBuilder: (ctx) => [
                                _buildPopupMenuItem(
                                    fonts.deleteChat.tr,
                                    0,
                                        () => chatCtrl.buildPopupDialog(
                                        widget.docId)),
                                _buildPopupMenuItem(fonts.star.tr, 1,
                                        () async {
                                      await FirebaseFirestore.instance
                                          .collection(
                                          collectionName.groupMessage)
                                          .doc(chatCtrl.pId)
                                          .collection(collectionName.chat)
                                          .doc(widget.docId)
                                          .update({
                                        "isFavourite": true,
                                        "favouriteId": chatCtrl.user["id"]
                                      });
                                    }),
                              ]),

                        ],
                      ),
                  ],
                ),
                if (widget.document!["type"] == MessageType.messageType.name)
                  Text(decryptMessage(widget.document!['content']))
                      .paddingSymmetric(
                      horizontal: Insets.i8, vertical: Insets.i10) .decorated(
                      color:  appCtrl.appTheme.primary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(AppRadius.r8)).paddingOnly(bottom: Insets.i8)
              ],
            ),
          ),

          if (chatCtrl.enableReactionPopup &&
              chatCtrl.selectedIndexId.contains(widget.docId))
            SizedBox(
                height: Sizes.s48,
                child: ReactionPopup(
                  reactionPopupConfig: ReactionPopupConfiguration(
                      shadow: BoxShadow(
                          color: Colors.grey.shade400, blurRadius: 20)),
                  onEmojiTap: (val) => GroupOnTapFunctionCall()
                      .onEmojiSelect(chatCtrl, widget.docId, val),
                  showPopUp: chatCtrl.showPopUp,
                ))
        ],
      );
    });
  }
}

PopupMenuItem _buildPopupMenuItem(
    String title, int position, GestureTapCallback? onTap) {
  return PopupMenuItem(
    onTap: onTap,
    value: position,
    child: Row(
      children: [
        Text(
          title,
          style:
          AppCss.poppinsMedium14.textColor(appCtrl.appTheme.blackColor),
        )
      ],
    ),
  );
}