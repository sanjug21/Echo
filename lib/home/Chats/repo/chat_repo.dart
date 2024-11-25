import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/echo_user.dart';
import '../../../auth/storage.dart';
import '../../../common/Widget/snack_bar.dart';
import '../../../common/message_enum.dart';
import '../../../common/message_reply_provider.dart';
import '../modals/chat_contact.dart';
import '../modals/message.dart';

final chatRepoProvider = Provider((ref) => ChatRepo(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepo {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepo({required this.firestore, required this.auth});

  // Stream<List<String>> getContacts(){
  //   return firestore
  //       .collection('Users')
  //       .doc(auth.currentUser!.uid)
  //       .collection('chats').orderBy(field)
  // }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .asyncMap((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));

      }

      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .asyncMap((events) async {
      List<ChatContact> contacts = [];
      for (var document in events.docs) {
        var chatContacts = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('Users')
            .doc(chatContacts.contactId)
            .get();
        var user = EchoUser.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: user.uid,
            senderId: chatContacts.senderId,
            lastMessage: chatContacts.lastMessage,
            timeSent: chatContacts.timeSent,
            isSeen: chatContacts.isSeen));
      }
      return contacts;
    });
  }

  void chatMsgSeen(
      BuildContext context, String receiverUserId, String messageId) async {
    try {
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({"isSeen": true});
      await firestore
          .collection('Users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .update({'isSeen': true});
      await firestore
          .collection('Users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void sendTextMsg(
      {required BuildContext context,
      required String text,
      required String receiverUserId,
      required EchoUser senderUser,
      required MessageReply? messageReply}) async {
    var timeSent = DateTime.now();
    var messageId = const Uuid().v4();
    var receiverData =
        await firestore.collection('Users').doc(receiverUserId).get();
    EchoUser receiverUser = EchoUser.fromMap(receiverData.data()!);

    saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.name,
        receiverUsername: receiverUser.name,
        messageType: MessageEnum.text,
        messageReply: messageReply);
    saveMessageToContactSubCollection(
        sender: senderUser,
        receiver: receiverUser,
        text: text,
        timeSent: timeSent);
  }

  void sendFileMsg(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required EchoUser senderUser,
      required Ref ref,
      required MessageEnum messageEnum,
      required MessageReply? messageReply}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String url = await ref.read(firebaseStorageProvider).storeFileToFirebase(
          'chat/${messageEnum.type}/${senderUser.uid}/$receiverUserId/$messageId',
          file);
      EchoUser receiverUser;
      var userData =
          await firestore.collection('Users').doc(receiverUserId).get();

      receiverUser = EchoUser.fromMap(userData.data()!);
      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      saveMessageToContactSubCollection(
          sender: senderUser,
          receiver: receiverUser,
          text: contactMsg,
          timeSent: timeSent);
      saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: url,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUser.name,
          receiverUsername: receiverUser.name,
          messageType: messageEnum,
          messageReply: messageReply);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> saveMessageToContactSubCollection({
    required EchoUser sender,
    required EchoUser receiver,
    required String text,
    required DateTime timeSent,
  }) async {
    var senderChatContact = ChatContact(
        name: receiver.name,
        profilePic: receiver.profilePic,
        senderId: sender.uid,
        contactId: receiver.uid,
        lastMessage: text,
        timeSent: timeSent,
        isSeen: false);
    var receiverChatContact = ChatContact(
        name: sender.name,
        profilePic: sender.profilePic,
        senderId: sender.uid,
        contactId: sender.uid,
        lastMessage: text,
        timeSent: timeSent,
        isSeen: false);

    await firestore
        .collection('Users')
        .doc(sender.uid)
        .collection('chats')
        .doc(receiver.uid)
        .set(senderChatContact.toMap());
    await firestore
        .collection('Users')
        .doc(receiver.uid)
        .collection('chats')
        .doc(sender.uid)
        .set(receiverChatContact.toMap());
  }

  Future<void> saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String receiverUsername,
    required MessageEnum messageType,
    required MessageReply? messageReply,
  }) async {

    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      react: "",
      date: timeSent,
      messageId: messageId,
      isSeen: false,
      edited: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? username
              : receiverUsername,
      repliedMsgType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    await firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    await firestore
        .collection('Users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  Future<String> deleteChat(bool forBoth, List<String> list) async {
    String res = "";
    try {
      for (String s in list) {
        await firestore
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('chats')
            .doc(s)
            .delete();
        if (forBoth) {
          await firestore
              .collection('Users')
              .doc(s)
              .collection('chats')
              .doc(auth.currentUser!.uid)
              .collection('messages')
              .where('senderId', isEqualTo: auth.currentUser!.uid)
              .get()
              .then((snapshot) {
            for (var doc in snapshot.docs) {
              doc.reference.delete();
            }
          });
        }
        res = "Deleted";
      }
    } catch (e) {
      e.toString();
    }
    return res;
  }
}
