
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/auth_controller.dart';
import '../../../common/message_enum.dart';
import '../../../common/message_reply_provider.dart';
import '../modals/chat_contact.dart';
import '../modals/message.dart';
import '../repo/chat_repo.dart';

final chatControllerProvider = Provider((ref){
  final chatRepo=ref.watch(chatRepoProvider);
  return ChatController(chatRepo: chatRepo, ref: ref);
});


class ChatController{
  final ChatRepo chatRepo;
  final Ref ref;

  ChatController({required this.chatRepo, required this.ref});

  Stream<List<Message>> chatStream(String receiverUserId){
    return chatRepo.getChatStream(receiverUserId);
  }


  void sendTextMessage(BuildContext context,String text,String receiverUserId){
    final messageReply=ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData((value)=>chatRepo.sendTextMsg(context: context, text: text, receiverUserId: receiverUserId, senderUser: value!, messageReply:messageReply ));
    ref.read(messageReplyProvider.notifier).update((state)=>null);
  }
  Stream<List<ChatContact>> chatContacts(){
    return chatRepo.getChatContacts();
  }


  void sendFileMessage(BuildContext context,File file,String receiverUserId,MessageEnum messageEnum){
    final messageReply=ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData((value)=>chatRepo.sendFileMsg(context: context, file: file, receiverUserId: receiverUserId, senderUser: value!, ref: ref, messageEnum: messageEnum, messageReply: messageReply,));
    ref.read(messageReplyProvider.notifier).update((state)=>null);
  }

  void chatMsgSeen(
      BuildContext context,
      String receiverUserId,
      String messageId
      ){
    chatRepo.chatMsgSeen(context, receiverUserId, messageId);
  }
  Future<String> deleteChat(bool forBoth,List<String> list){
    return chatRepo.deleteChat(forBoth, list);
  }


// ignore_for_file: file_names

 }
