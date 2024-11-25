// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/auth/auth_controller.dart';
import 'package:echo/common/Widget/bottom_sheet.dart';
import 'package:echo/common/color.dart';
import 'package:echo/home/Post/post_Repo/add_thought.dart';
import 'package:echo/home/Post/post_Repo/user_posts.dart';

import 'package:echo/home/Post/post_card.dart';
import 'package:echo/home/Post/post_controller/post_controller.dart';
import 'package:echo/home/Post/search_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostScreen extends ConsumerStatefulWidget {
  final String id = "";
  const PostScreen({
    super.key,
  });

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  // ignore: non_constant_identifier_names
  List<String> Contacts = [];

  void allContacts() async {
    // Contacts =await ref.read(contactControllerProvider).allContacts();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: ref.read(authControllerProvider).getUserStatus(""),
        builder: (context, user) {
          if (user.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: tabColor,
              ),
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: SizedBox(
                  width: size.width * .7,
                  child: Text(
                    "hello ${user.data!.name}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                actions: [
                  MenuAnchor(

                      builder: (BuildContext context, MenuController controller,
                          Widget? child) {
                        return IconButton(
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          icon: const Icon(Icons.add),
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () => addPic(context, false),
                          child: Text("Image"),
                        ),
                        MenuItemButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddThought())),
                          child: Text("Thought"),
                        )
                      ]),
                  IconButton(
                    onPressed: ()=>Navigator.pushNamed(context,SearchUser.routeName),
                    icon: const Icon(Icons.search),
                  ),
                  //IconButton(onPressed:(){},icon:const Icon(Icons.more_vert_rounded))
                ],
                backgroundColor: appBarColor,
                surfaceTintColor: backgroundColor,
              ),
              body: Container(
                color: backgroundColor,
                child: StreamBuilder(
                    stream: ref.watch(postControllerProvider).getPosts(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: tabColor,
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Post post = Post.fromPost(
                                snapshot.data!.docs[index].data());

                            return PostCard(post: post, profile: false);
                          });
                    }),
              ));
        });
  }
}
