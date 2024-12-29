// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/common/Widget/snack_bar.dart';
import 'package:echo/common/color.dart';
import 'package:echo/home/Chats/user_chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Profile/display_img.dart';
import 'contacts/contact_screen.dart';
import 'controller/chatController.dart';
import 'modals/chat_contact.dart';

class ChatFeedScreen extends ConsumerStatefulWidget {
  const ChatFeedScreen({super.key});

  @override
  ConsumerState<ChatFeedScreen> createState() => _ChatFeedScreenState();
}

class _ChatFeedScreenState extends ConsumerState<ChatFeedScreen> {
  List<String> deleteList = [];
  void deleteChats(bool forBoth) async {
    String res =
        await ref.read(chatControllerProvider).deleteChat(forBoth, deleteList);
    if (res == 'Deleted') {
      showSnackBar(context, res);
      Navigator.pop(context);
      setState(() {
        deleteList.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "echo",
          style: TextStyle(
            fontSize: 28,
          ),
        ),
        actions: deleteList.isNotEmpty
            ? [
                IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Center(
                                  child: Text(
                                "Do you want to delete these chats",
                                style: TextStyle(fontSize: 15),
                              )),
                              actions: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => deleteChats(false),
                                      child: Text(
                                        "Delete for me",
                                        style: TextStyle(color: tabColor),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => deleteChats(true),
                                      child: Text(
                                        "Delete for both",
                                        style: TextStyle(color: tabColor),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                    icon: Icon(Icons.delete))
              ]
            : [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
              ],
        leading: deleteList.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    deleteList.clear();
                  });
                },
                icon: Icon(Icons.clear))
            : null,
        backgroundColor: appBarColor,
        surfaceTintColor: tabColor,
      ),
      body: Container(
        color: backgroundColor,
        height: size.height,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder<List<ChatContact>>(
          stream: ref.read(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            // if(snapshot.connectionState==ConnectionState.waiting){
            //   return Container();
            // }

            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatContactData = snapshot.data![index];
                  Timestamp t = chatContactData.timeSent as Timestamp;
                  DateTime date = t.toDate();
                  bool seen = !chatContactData.isSeen &&
                      chatContactData.senderId !=
                          FirebaseAuth.instance.currentUser!.uid;

                  return Container(
                    color: deleteList.contains(chatContactData.contactId)
                        ? appBarColor
                        : Colors.transparent.withOpacity(.5),
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      onTap: () {
                        if (deleteList.isNotEmpty) {
                          setState(() {
                            if (deleteList
                                .contains(chatContactData.contactId)) {
                              deleteList.remove(chatContactData.contactId);
                            } else {
                              deleteList.add(chatContactData.contactId);
                            }
                          });
                        } else {
                          Navigator.pushNamed(context, ChatScreen.routeName,
                              arguments: {
                                'id': chatContactData.contactId,
                                'name': chatContactData.name,
                                'pic': chatContactData.profilePic
                              });
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          deleteList.add(chatContactData.contactId);
                        });
                      },
                      title: Text(
                        chatContactData.name,
                        style: const TextStyle(
                            fontSize: 18, overflow: TextOverflow.ellipsis),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            chatContactData.lastMessage,
                            style: const TextStyle(
                                fontSize: 15, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      leading: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayImg(
                                    img: chatContactData.profilePic,
                                    name: chatContactData.name))),
                        child: ClipOval(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: CachedNetworkImage(
                              imageUrl: chatContactData.profilePic,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${date.hour}:${date.minute}",
                            // DateFormat.Hm().format(chatContactData.timeSent),
                            style: TextStyle(
                              color: !seen ? Colors.grey : Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          seen
                              ? Text(
                                  'new message',
                                  style: TextStyle(
                                    color: tabColor,
                                    fontSize: 15,
                                  ),
                                )
                              : Text(
                                  "${date.day}/${date.month}/${date.year}",
                                  // DateFormat.Hm().format(chatContactData.timeSent),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ContactScreen.routeName);
        },
        backgroundColor: tabColor,
        splashColor: appBarColor,
        elevation: 50,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_outlined,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}
