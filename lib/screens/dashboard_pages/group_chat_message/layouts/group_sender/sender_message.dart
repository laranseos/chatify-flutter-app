import 'dart:developer';
import 'package:chatify_web/screens/dashboard_pages/group_chat_message/group_on_tap_function_class.dart';
import '../../../../../config.dart';

class GroupSenderMessage extends StatefulWidget {
  final DocumentSnapshot? document;
  final int? index;
  final String? currentUserId, docId;

  const GroupSenderMessage(
      {Key? key, this.document, this.index, this.currentUserId, this.docId})
      : super(key: key);

  @override
  State<GroupSenderMessage> createState() => _GroupSenderMessageState();
}

class _GroupSenderMessageState extends State<GroupSenderMessage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Stack(
        alignment: Alignment.topLeft,
        children: [
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
                    : appCtrl.appTheme.bgColor,
                margin: const EdgeInsets.only(bottom: 2.0),
                padding: EdgeInsets.only(
                    top: chatCtrl.selectedIndexId.contains(widget.docId)
                        ? Insets.i20
                        : 0,
                    left: Insets.i10,
                    right: Insets.i10),
                child: Column(
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
                              const HSpace(Sizes.s5),
                              Icon(
                                Icons.emoji_emotions,
                                color: appCtrl.appTheme.whiteColor,size: Sizes.s15,
                              )
                                  .paddingAll(Insets.i2)
                                  .decorated(
                                      shape: BoxShape.circle,
                                      color: appCtrl.appTheme.grey
                                          .withOpacity(.5))
                                  .inkWell(onTap: () {
                                chatCtrl.showPopUp = true;
                                chatCtrl.enableReactionPopup = true;

                                if (!chatCtrl.selectedIndexId
                                    .contains(widget.docId)) {
                                  if (chatCtrl.showPopUp == false) {
                                    chatCtrl.selectedIndexId.add(widget.docId);
                                  } else {
                                    chatCtrl.selectedIndexId = [];
                                    chatCtrl.selectedIndexId.add(widget.docId);
                                  }
                                  chatCtrl.update();
                                }
                                chatCtrl.update();
                              }),
                            ],
                          ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              if (widget.document!["type"] ==
                                  MessageType.text.name)
                                // Text
                                GroupContent(
                                    isSearch: chatCtrl.searchChatId
                                        .contains(widget.index),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId),
                                    onLongPress: () => chatCtrl
                                        .onLongPressFunction(widget.docId),
                                    document: widget.document),
                              if (widget.document!["type"] ==
                                  MessageType.image.name)
                                GroupSenderImage(
                                    onPressed: () => GroupOnTapFunctionCall()
                                        .imageTap(chatCtrl, widget.docId,
                                            widget.document),
                                    document: widget.document,
                                    onLongPress: () => chatCtrl
                                        .onLongPressFunction(widget.docId)),
                              if (widget.document!["type"] ==
                                  MessageType.contact.name)
                                GroupContactLayout(
                                    currentUserId: widget.currentUserId,
                                    onLongPress: () => chatCtrl
                                        .onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId),
                                    document: widget.document),
                              if (widget.document!["type"] ==
                                  MessageType.location.name)
                                GroupLocationLayout(
                                    document: widget.document,
                                    currentUserId: chatCtrl.id,
                                    onLongPress: () => chatCtrl
                                        .onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .locationTap(chatCtrl, widget.docId,
                                            widget.document)),
                              if (widget.document!["type"] ==
                                  MessageType.video.name)
                                GroupVideoDoc(
                                    currentUserId: widget.currentUserId,
                                    document: widget.document,
                                    onLongPress: () => chatCtrl
                                        .onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .locationTap(chatCtrl, widget.docId,
                                            widget.document)),
                              if (widget.document!["type"] ==
                                  MessageType.audio.name)
                                GroupAudioDoc(
                                    currentUserId: widget.currentUserId,
                                    document: widget.document,
                                    onLongPress: () => chatCtrl
                                        .onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId)),
                              if (widget.document!["type"] ==
                                  MessageType.doc.name)
                                (decryptMessage(widget.document!['content'])
                                        .contains(".pdf"))
                                    ? PdfLayout(
                                        isGroup: true,
                                        document: widget.document,
                                        onLongPress: () => chatCtrl
                                            .onLongPressFunction(widget.docId),
                                        onTap: () => GroupOnTapFunctionCall()
                                            .pdfTap(chatCtrl, widget.docId,
                                                widget.document))
                                    : (decryptMessage(widget.document!['content'])
                                            .contains(".doc"))
                                        ? DocxLayout(
                                            currentUserId: widget.currentUserId,
                                            document: widget.document,
                                            isGroup: true,
                                            onLongPress: () =>
                                                chatCtrl.onLongPressFunction(
                                                    widget.docId),
                                            onTap: () =>
                                                GroupOnTapFunctionCall().docTap(
                                                    chatCtrl, widget.docId, widget.document))
                                        : (decryptMessage(widget.document!['content']).contains(".xlsx") || decryptMessage(widget.document!['content']).contains(".xls"))
                                            ? ExcelLayout(
                                                currentUserId:
                                                    widget.currentUserId,
                                                isGroup: true,
                                                onLongPress: () => chatCtrl
                                                    .onLongPressFunction(
                                                        widget.docId),
                                                onTap: () =>
                                                    GroupOnTapFunctionCall()
                                                        .excelTap(
                                                            chatCtrl,
                                                            widget.docId,
                                                            widget.document),
                                                document: widget.document,
                                              )
                                            : (decryptMessage(widget.document!['content']).contains(".jpg") || decryptMessage(widget.document!['content']).contains(".png") || decryptMessage(widget.document!['content']).contains(".heic") || decryptMessage(widget.document!['content']).contains(".jpeg"))
                                                ? DocImageLayout(currentUserId: widget.currentUserId, isGroup: true, document: widget.document, onLongPress: () => chatCtrl.onLongPressFunction(widget.docId), onTap: () => GroupOnTapFunctionCall().docImageTap(chatCtrl, widget.docId, widget.document))
                                                : Container(),
                              if (widget.document!["type"] ==
                                  MessageType.gif.name)
                                GifLayout(
                                    currentUserId: widget.currentUserId,
                                    isGroup: true,
                                    document: widget.document,
                                    onLongPress: () => chatCtrl
                                        .onLongPressFunction(widget.docId),
                                    onTap: () => GroupOnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId))
                            ]),
                      ],
                    ),
                    if (widget.document!["type"] ==
                        MessageType.messageType.name)
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
}
