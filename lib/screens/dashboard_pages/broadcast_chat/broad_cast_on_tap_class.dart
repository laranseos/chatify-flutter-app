import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config.dart';

class BroadcastOnTapFunctionCall {
  //contentTap
  contentTap(BroadcastChatController chatCtrl, docId) {
    if (!chatCtrl.selectedIndexId.contains(docId)) {
      chatCtrl.selectedIndexId.add(docId);
    } else {
      chatCtrl.selectedIndexId.remove(docId);
    }
    chatCtrl.update();
  }

  //image tap
  imageTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

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
      log("result : $result");
      log("result : $response ");
    }
  }

  //location tap
  locationTap(BroadcastChatController chatCtrl, docId, document) {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

      if (!chatCtrl.selectedIndexId.contains(docId)) {
        chatCtrl.selectedIndexId.add(docId);
      } else {
        chatCtrl.selectedIndexId.remove(docId);
      }
      chatCtrl.update();
    } else {
      launchUrl(Uri.parse(document!["content"]));
    }
  }

  //pdf tap
  pdfTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

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
      log("result : $openResult");
      log("result : $result");
      log("result : $response ");
    }
  }

  //doc tap
  docTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

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
      log("result : $openResult");
      log("result : $result");
      log("result : $response ");
    }
  }

  //excel tap
  excelTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

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
      log("result : $openResult");
      log("result : $result");
      log("result : $response ");
    }
  }

  //doc image tap
  docImageTap(BroadcastChatController chatCtrl, docId, document) async {
    if (chatCtrl.selectedIndexId.isNotEmpty) {

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
      log("result : $openResult");
      log("result : $result");
      log("result : $response ");
    }
  }

}
