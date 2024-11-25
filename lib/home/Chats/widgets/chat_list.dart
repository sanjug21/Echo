import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/common/months.dart';
import 'package:echo/home/Chats/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/message_enum.dart';
import '../../../common/message_reply_provider.dart';
import '../controller/chatController.dart';
import '../modals/message.dart';
import 'my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList(
    this.receiverUserId, {
    super.key,
  });

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  void onMessageSwipe(String msg, bool isMe, MessageEnum messageEnum) {
    ref
        .read(messageReplyProvider.notifier)
        .update((state) => MessageReply(msg, isMe, messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting ) {
          //   return Container();
          // }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });

          if(snapshot.hasData) {
            return Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            child: ListView.builder(
              controller: scrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];

                var timeSent = DateFormat.Hm().format(messageData.timeSent);
                if (!messageData.isSeen &&
                    messageData.receiverId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(chatControllerProvider).chatMsgSeen(
                      context, widget.receiverUserId, messageData.messageId);
                }


                Timestamp t = messageData.date as Timestamp;
                DateTime date = t.toDate();

                String curr="${date.day} ${months[date.month-1]}, ${date.year}";

                String pre="";
                if(index>0){
                  Timestamp t = snapshot.data![index-1].date as Timestamp;
                  DateTime d = t.toDate();
                  pre="${d.day} ${months[d.month-1]}, ${d.year}";
                }


                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return Column(
                    children: [
                      if (index == 0)
                        Center(
                          child: Container(
                            height: 25,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.transparent.withOpacity(.5)),
                            child: Center(
                                child: Text(curr)),
                          ),
                        ),
                      if(index>0  && pre!=curr )Center(child: Container(
                        height: 25,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.transparent.withOpacity(.5)),
                        child: Center(
                            child: Text(curr)),
                      ),),
                      MyMessageCard(
                          message: messageData.text,
                          date: timeSent,
                          type: messageData.type,
                          replyMessageType: messageData.repliedMsgType,
                          onLeftSwipe: () => onMessageSwipe(
                              messageData.text, true, messageData.type),
                          username: messageData.repliedTo,
                          repliedText: messageData.repliedMessage,
                          isSeen: messageData.isSeen),
                    ],
                  );
                }

                return Column(
                  children: [
                    if (index == 0)
                      Center(
                        child: Container(
                          height: 25,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.transparent.withOpacity(.5)),
                          child: Center(
                              child: Text(curr)),
                        ),
                      ),
                    if(index>0 && pre!=curr )Center(child: Container(
                      height: 25,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent.withOpacity(.5)),
                      child: Center(
                          child: Text(curr)),
                    ),),
                    SenderMessageCard(
                      message: messageData.text,
                      date: timeSent,
                      type: messageData.type,
                      replyMessageType: messageData.repliedMsgType,
                      onLeftSwipe: () {
                        onMessageSwipe(
                            messageData.text, false, messageData.type);
                      },
                      username: messageData.repliedTo,
                      repliedText: messageData.repliedMessage,
                    ),
                  ],
                );
              },
            ),
          );
          }
          return Container();
        });
  }
}
