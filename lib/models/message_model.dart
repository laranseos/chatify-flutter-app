
class MessageModel {
  final String sender;
  final String receiver;
  final String content;
  final String timestamp;
  final String type;
  final String messageType;

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.messageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'timestamp': timestamp,
      'type': type,
      'messageType': messageType,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      sender: map['sender'] ?? '',
      receiver: map['receiver'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'],
      type: map['type'] ?? '',
      messageType: map['messageType'] ?? "",
    );
  }
}
