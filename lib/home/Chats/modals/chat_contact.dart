

class ChatContact {
  final String name;
  final String profilePic;
  final String senderId;
  final String contactId;
  final String lastMessage;

  // ignore: prefer_typing_uninitialized_variables
  final timeSent;
  final bool isSeen;

  ChatContact(
      {required this.name,
      required this.profilePic,
        required this.senderId,
      required this.contactId,
      required this.lastMessage,

      required this.timeSent,required this.isSeen});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'senderId':senderId,
      'contactId': contactId,
      'timeSent': timeSent,
      'lastMessage': lastMessage,

      'isSeen':isSeen

    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {

    return ChatContact(
        name: map['name'] ?? '',
        profilePic: map['profilePic'] ?? '',
        senderId: map['senderId'],
        contactId: map['contactId'] ?? '',
        timeSent: map['timeSent'],
        lastMessage: map['lastMessage'] ?? '',
        isSeen: map['isSeen']);
  }
}
