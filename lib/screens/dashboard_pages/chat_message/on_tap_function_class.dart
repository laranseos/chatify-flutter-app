import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config.dart';

class OnTapFunctionCall {
  //contentTap
  contentTap(ChatController chatCtrl, docId) {

    if (chatCtrl.selectedIndexId.isNotEmpty) {
      chatCtrl.enableReactionPopup = false;
      chatCtrl.showPopUp = false;
      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    }

  }

  //image tap
  imageTap(ChatController chatCtrl, docId, document) async {
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
      var filePath = tempDir!.path +
          (decryptMessage(document!['content']).contains("-BREAK-")
              ? decryptMessage(document!['content']).split("-BREAK-")[0]
              : (decryptMessage(document!['content'])));
      final response = await dio.download(
          decryptMessage(document!['content']).contains("-BREAK-")
              ? decryptMessage(document!['content']).split("-BREAK-")[1]
              : decryptMessage(document!['content']),
          filePath);
      final result = await OpenFilex.open(filePath);


      openResult = "type=${result.type}  message=${result.message}";
      log("result : $openResult");

      log("OPEN : $result ");
      log("OPEN : $response ");
    }
  }

  //location tap
  locationTap(ChatController chatCtrl, docId, document) {
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
      launchUrl(Uri.parse(decryptMessage(decryptMessage(document!['content']))));
    }
  }

  //pdf tap
  pdfTap(ChatController chatCtrl, docId, document) async {
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
  docTap(ChatController chatCtrl, docId, document) async {
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
  excelTap(ChatController chatCtrl, docId, document) async {
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
  docImageTap(ChatController chatCtrl, docId, document) async {
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
  onEmojiSelect(ChatController chatCtrl,docId,emoji) async {
    chatCtrl.selectedIndexId = [];
    chatCtrl.showPopUp = false;
    chatCtrl.enableReactionPopup = false;
    await FirebaseFirestore.instance
        .collection(collectionName.messages)
        .doc(chatCtrl.chatId)
        .collection(collectionName.chat)
        .doc(docId)
        .update({"emoji": emoji});
  }
}
