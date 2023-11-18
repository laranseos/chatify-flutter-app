import 'dart:developer';

import '../../../../../config.dart';

class SenderMessage extends StatefulWidget {
  final dynamic document;
  final int? index;
  final String? docId;

  const SenderMessage({Key? key, this.document, this.index, this.docId})
      : super(key: key);

  @override
  State<SenderMessage> createState() => _SenderMessageState();
}

class _SenderMessageState extends State<SenderMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      log("TY{EE : ${widget.document!["type"]}");
      return Stack(alignment: Alignment.topLeft, children: [
        MouseRegion(
          onHover: (val) {
            chatCtrl.isHover = true;
            chatCtrl.isSelectedHover = widget.index!;
            chatCtrl.update();
          },
          onExit: (exit) {
            chatCtrl.isHover = false;
            chatCtrl.update();
          },
          onEnter: (enter) {
            chatCtrl.isHover = true;
            chatCtrl.update();
          },
          child: Container(
              color: chatCtrl.selectedIndexId.contains(widget.docId)
                  ? appCtrl.appTheme.primary.withOpacity(.08)
                  : appCtrl.appTheme.transparentColor,
              margin: const EdgeInsets.only(bottom: 2.0),
              padding: EdgeInsets.only(
                  top: chatCtrl.selectedIndexId.contains(widget.docId)
                      ? Insets.i20
                      : 0,
                  left: Insets.i10,
                  right: Insets.i10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (chatCtrl.isHover == true &&
                          chatCtrl.isSelectedHover == widget.index)
                        Row(
                          children: [
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
                                                .collection(collectionName.messages)
                                                .doc(chatCtrl.chatId)
                                                .collection(collectionName.chat)
                                                .doc(widget.docId)
                                                .update({"isFavourite": true,"favouriteId":appCtrl.user["id"]});
                                      }),
                                ]),
                            const HSpace(Sizes.s5),
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
                          ],
                        ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            if (widget.document!["type"] ==
                                MessageType.text.name)
                              // Text
                              Content(
                                  onTap: () => OnTapFunctionCall()
                                      .contentTap(chatCtrl, widget.docId),
                                  onLongPress: () => chatCtrl
                                      .onLongPressFunction(widget.docId),
                                  document: widget.document),
                            if (widget.document!["type"] ==
                                MessageType.image.name)
                              SenderImage(
                                  onPressed: () => OnTapFunctionCall().imageTap(
                                      chatCtrl, widget.docId, widget.document),
                                  document: widget.document,
                                  onLongPress: () => chatCtrl
                                      .onLongPressFunction(widget.docId)),
                            if (widget.document!["type"] ==
                                MessageType.contact.name)
                              ContactLayout(
                                      onTap: () => OnTapFunctionCall()
                                          .contentTap(chatCtrl, widget.docId),
                                      onLongPress: () => chatCtrl
                                          .onLongPressFunction(widget.docId),
                                      document: widget.document)
                                  .paddingSymmetric(vertical: Insets.i8),
                            if (widget.document!["type"] ==
                                MessageType.location.name)
                              LocationLayout(
                                  document: widget.document,
                                  onLongPress: () => chatCtrl
                                      .onLongPressFunction(widget.docId),
                                  onTap: () => OnTapFunctionCall().locationTap(
                                      chatCtrl, widget.docId, widget.document)),
                            if (widget.document!["type"] ==
                                MessageType.video.name)
                              VideoDoc(
                                  document: widget.document,
                                  onLongPress: () => chatCtrl
                                      .onLongPressFunction(widget.docId),
                                  onTap: () => OnTapFunctionCall().locationTap(
                                      chatCtrl, widget.docId, widget.document)),
                            if (widget.document!["type"] ==
                                MessageType.audio.name)
                              AudioDoc(
                                  document: widget.document,
                                  onLongPress: () => chatCtrl
                                      .onLongPressFunction(widget.docId),
                                  onTap: () => OnTapFunctionCall()
                                      .contentTap(chatCtrl, widget.docId)),
                            if (widget.document!["type"] ==
                                MessageType.doc.name)
                              (decryptMessage(widget.document!["content"])
                                      .contains(".pdf"))
                                  ? PdfLayout(
                                      onTap: () => OnTapFunctionCall().pdfTap(
                                          chatCtrl,
                                          widget.docId,
                                          widget.document),
                                      document: widget.document,
                                      onLongPress: () => chatCtrl
                                          .onLongPressFunction(widget.docId))
                                  : (decryptMessage(widget.document!["content"])
                                          .contains(".doc"))
                                      ? DocxLayout(
                                          document: widget.document,
                                          onTap: () => OnTapFunctionCall().docTap(
                                              chatCtrl,
                                              widget.docId,
                                              widget.document),
                                          onLongPress: () => chatCtrl.onLongPressFunction(
                                              widget.docId))
                                      : (decryptMessage(widget.document!["content"])
                                                  .contains(".xlsx") ||
                                              decryptMessage(widget.document!["content"]).contains(".xls"))
                                          ? ExcelLayout(
                                              onTap: () => OnTapFunctionCall()
                                                  .excelTap(
                                                      chatCtrl,
                                                      widget.docId,
                                                      widget.document),
                                              onLongPress: () =>
                                                  chatCtrl.onLongPressFunction(
                                                      widget.docId),
                                              document: widget.document,
                                            )
                                          : (decryptMessage(widget.document!["content"]).contains(".jpg") || decryptMessage(widget.document!["content"]).contains(".png") || decryptMessage(widget.document!["content"]).contains(".heic") || decryptMessage(widget.document!["content"]).contains(".jpeg"))
                                              ? DocImageLayout(document: widget.document, onTap: () => OnTapFunctionCall().docImageTap(chatCtrl, widget.docId, widget.document), onLongPress: () => chatCtrl.onLongPressFunction(widget.docId))
                                              : Container(),
                            if (widget.document!["type"] ==
                                MessageType.gif.name)
                              GifLayout(
                                onTap: () => OnTapFunctionCall()
                                    .contentTap(chatCtrl, widget.docId),
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                document: widget.document,
                              )
                          ]),

                    ],
                  ),
                  if (widget.document!["type"] == MessageType.messageType.name)
                    Text(decryptMessage(widget.document!['content']))
                        .paddingSymmetric(
                            horizontal: Insets.i8, vertical: Insets.i10)
                        .decorated(
                            color: appCtrl.appTheme.primary.withOpacity(.2),
                            borderRadius: BorderRadius.circular(AppRadius.r8))
                        .paddingOnly(bottom: Insets.i8)
                ],
              )),
        ),
        if (chatCtrl.enableReactionPopup &&
            chatCtrl.selectedIndexId.contains(widget.docId))
          SizedBox(
              height: Sizes.s48,
              child: ReactionPopup(
                reactionPopupConfig: ReactionPopupConfiguration(
                    shadow:
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 20)),
                onEmojiTap: (val) => OnTapFunctionCall()
                    .onEmojiSelect(chatCtrl, widget.docId, val),
                showPopUp: chatCtrl.showPopUp,
              ))
      ]);
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