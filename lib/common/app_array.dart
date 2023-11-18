
import '../config.dart';

class AppArray{
  //language list
  var languageList = [
    {'title': 'english', 'locale': const Locale('en', 'US')},
    {'title': 'arabic', 'locale': const Locale('ar', 'AE')},
    {'title': 'hindi', 'locale': const Locale('hi', 'IN')},
    {'title': 'korean', 'locale': const Locale('ko', 'KR')}
  ];

  //bottom list
  var bottomList = [
    {'icon': svgAssets.chat, 'title': "chats",'iconSelected': svgAssets.chatFilled},
    {'icon': svgAssets.status, 'title': "status",'iconSelected': svgAssets.storyFilled},
    {'icon': svgAssets.call, 'title': "calls",'iconSelected': svgAssets.callFilled},
  ];

  //action list
  var actionList = [
    {'title': "newBroadCast"},
    {'title': "newGroup"},
    {'title': "setting"},
  ];


  //statusAction list
  var statusAction = [

    {'title': "setting"},
  ];

  //callAction list
  var callsAction = [

    {'title': "clearLogs"},
    {'title': "setting"}
  ];

  //setting list
  var settingList = [
    {'title': "language","icon" : svgAssets.language},
    {'title': "rtl","icon" : svgAssets.rtl},
    {'title': "theme","icon" : svgAssets.sun},
    {'title': "deleteAccount","icon" : svgAssets.trash},
    {'title': "logout","icon" : svgAssets.logout},
  ];

  //background list
  var backgroundList = [
    {"image": imageAssets.user},
    {"image": imageAssets.background2},
    {"image": imageAssets.background3},
    {"image": imageAssets.background4},
    {"image": imageAssets.background5}
  ];
}