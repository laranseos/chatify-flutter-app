import 'dart:developer';

import 'package:dio/dio.dart';


import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config.dart';

class GroupOnTapFunctionCall {
  //contentTap
  contentTap(GroupChatMessageController chatCtrl, docId) {

    if (chatCtrl.selectedIndexId.isNotEmpty) {
      chatCtrl.enableReactionPopup = false;
      chatCtrl.showPopUp = false;
    }
    if (!chatCtrl.selectedIndexId.contains(docId)) {
      chatCtrl.selectedIndexId.add(docId);
    } else {
      chatCtrl.selectedIndexId.remove(docId);
    }
    chatCtrl.update();
  }

  //image tap
  imageTap(GroupChatMessageController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {

      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();
      var filePath = tempDir!.path +
          (decryptMessage(document!['content']).contains("-BREAK-")
              ? decryptMessage(document!['content']).split("-BREAK-")[0]
              : (decryptMessage(document!['content'])));
      final response = await dio.download(
          decryptMessage(document!['content']).contains("-BREAK-")
              ? decryptMessage(document!['content']).split("-BREAK-")[1]
              : decryptMessage(document!['content']),
          filePath);
      var openResult = 'Unknown';
      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";
      log("OPEN : $openResult");
      log("OPEN : $result ");
      log("OPEN : $response ");
    }
  }

  //location tap
  locationTap(GroupChatMessageController chatCtrl, docId, document) {
    if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      launchUrl(Uri.parse(decryptMessage(document!['content'])));
    }
  }

  //pdf tap
  pdfTap(GroupChatMessageController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!['content']).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!['content']).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";
      OpenFilex.open(filePath);
      log("OPEN : $openResult");
      log("OPEN : $result ");
      log("OPEN : $response ");
    }
  }

  //doc tap
  docTap(GroupChatMessageController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!['content']).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!['content']).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";
      OpenFilex.open(filePath);
      log("OPEN : $openResult");
      log("OPEN : $result ");
      log("OPEN : $response ");
    }
  }

  //excel tap
  excelTap(GroupChatMessageController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!['content']).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!['content']).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";

      OpenFilex.open(filePath);
      log("OPEN : $openResult");
      log("OPEN : $result ");
      log("OPEN : $response ");
    }
  }

  //doc image tap
  docImageTap(GroupChatMessageController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty || chatCtrl.enableReactionPopup) {
      if (chatCtrl.selectedIndexId.isNotEmpty) {
        chatCtrl.enableReactionPopup = false;
        chatCtrl.showPopUp = false;
      }
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      var openResult = 'Unknown';
      var dio = Dio();
      var tempDir = await getExternalStorageDirectory();

      var filePath = tempDir!.path + decryptMessage(document!['content']).split("-BREAK-")[0];
      final response = await dio.download(
          decryptMessage(document!['content']).split("-BREAK-")[1], filePath);

      final result = await OpenFilex.open(filePath);

      openResult = "type=${result.type}  message=${result.message}";
      OpenFilex.open(filePath);
      log("OPEN : $openResult");
      log("OPEN : $result ");
      log("OPEN : $response ");
    }
  }

  //on emoji select
  onEmojiSelect(GroupChatMessageController chatCtrl,docId,emoji) async {
    chatCtrl.selectedIndexId = [];
    chatCtrl.showPopUp = false;
    chatCtrl.enableReactionPopup = false;
    chatCtrl.update();
    await FirebaseFirestore.instance
        .collection(collectionName.groupMessage)
        .doc(chatCtrl.pId)
        .collection(collectionName.chat)
        .doc(docId)
        .update({"emoji": emoji});
  }
}
