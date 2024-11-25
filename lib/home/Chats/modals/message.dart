import '../../../common/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  // ignore: prefer_typing_uninitialized_variables
  final date;
  final String messageId;
  final bool isSeen;
  final String react;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMsgType;
  final bool edited;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.react,
    required this.date,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMsgType,
    required this.edited
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'date':date,
      'react':react,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMsgType': repliedMsgType.type,
      'edited':edited
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {

    return Message(
        senderId: map['senderId'],
        receiverId: map['receiverId'],
        text: map['text'],
        type: (map['type'] as String).toEnum(),
        timeSent: DateTime.fromMicrosecondsSinceEpoch(map["timeSent"]),
        date: map['date'],
        messageId: map['messageId'],
        react: map['react'],
        isSeen: map['isSeen'],
        repliedMessage: map["repliedMessage"],
        repliedTo: map['repliedTo'],
        edited: map['edited'],
        repliedMsgType: (map['repliedMsgType'] as String).toEnum());
  }
}
