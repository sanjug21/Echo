import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/auth/auth_controller.dart';
import 'package:echo/auth/screens/login_screen.dart';
import 'package:echo/home/Post/post_Repo/add_thought.dart';
import 'package:echo/home/Post/post_card.dart';
import 'package:echo/home/Post/post_controller/post_controller.dart';
import 'package:echo/home/Profile/display_img.dart';
import 'package:echo/home/Profile/edit_screen.dart';
import 'package:echo/home/Profile/view_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/Widget/bottom_sheet.dart';
import '../../common/Widget/image_picker.dart';
import '../../common/color.dart';
import '../Post/add_post.dart';
import '../Post/post_Repo/user_posts.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String id;
  const ProfileScreen({super.key, required this.id});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool visible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.id != "") {
      setState(() {
        visible = false;
      });
    }
  }

  bool img = true;
  void signOut() async {
    String res = await ref.read(authControllerProvider).signOut();
    if (res == "out") {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    }
  }

  File? image;
  void pickImage(String path, bool profile) async {
    image = await pickImageFromGallery(context, path);
    Navigator.pop(context);
    Navigator.pushNamed(context, AddPost.routeName,
        arguments: {'image': image, 'profile': profile});
  }

  String name = "";
  String no = "";
  String bio = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: visible
          ? AppBar(
              title: Text(
                "echo",
                style: TextStyle( fontSize: 27),
              ),
              elevation: 50,
              actions: [
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditDetails(name: name, no: no, bio: bio))),
                    icon: Icon(Icons.settings)),
                IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title:
                                  Center(child: Text("Do you want to log out")),
                              actions: [
                                Center(
                                    child: ElevatedButton(
                                  onPressed: signOut,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: Text(
                                    "Log Out",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                              ],
                            )),
                    icon: Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.white,
                    )),
              ],
              backgroundColor:appBarColor,
              surfaceTintColor: tabColor,
            )
          : AppBar(
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(

        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream:
                      ref.watch(authControllerProvider).getUserStatus(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: tabColor,
                        ),
                      );
                    }
                    name = snapshot.data!.name;
                    no = snapshot.data!.phone;
                    bio = snapshot.data!.bio;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DisplayImg(
                                              img: snapshot.data!.profilePic,name: snapshot.data!.name,))),
                                  child: SizedBox(
                                    width: 130,
                                    height: 130,
                                    child: ClipOval(
                                      child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: CachedNetworkImage(imageUrl: snapshot.data!.profilePic,fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),),
                                if(widget.id == "")
                                  Positioned(
                                    bottom: 1,
                                    right: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color: tabColor,
                                        child: IconButton(
                                          onPressed: () => addPic(context,true,),
                                          icon: Icon(Icons.camera_alt_rounded),
                                          iconSize: 20,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: size.width -180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(snapshot.data!.name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bio",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        snapshot.data!.bio,
                                        style: TextStyle(
                                          fontSize: 17,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: tabColor,
                        ),
                        StatefulBuilder(builder: (context, setState) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: size.height-325),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              img = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.grid_view_rounded,
                                            color:
                                                img ? appBarColor: Colors.white,
                                          )),
                                      Container(
                                        color: Colors.white,
                                        width: 1,
                                        height: 20,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              img = false;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.linear_scale_sharp,
                                            color:
                                                img ? Colors.white : appBarColor,
                                          )),
                                    ],
                                  ),
                                  Divider(
                                    color: tabColor,
                                  ),
                                  img
                                      ? StreamBuilder(
                                          stream: ref
                                              .watch(postControllerProvider)
                                              .userPosts(widget.id, true),
                                          builder: (context,
                                              AsyncSnapshot<
                                                      QuerySnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  color: tabColor,
                                                ),
                                              );
                                            }
                                            if (snapshot.data!.docs.isEmpty) {
                                              return Center(
                                                child: Text("No post available"),
                                              );
                                            }
                                            return Expanded(
                                                child: GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4),
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Post post = Post.fromPost(
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data());
                                                      return Container(
                                                          color: Colors.black38,
                                                          child: InkWell(
                                                              onTap: () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    ViewPost
                                                                        .routeName,
                                                                    arguments:
                                                                        post);
                                                              },
                                                              child: Image.network(
                                                                  post.postUrl,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  frameBuilder:
                                                                      (context,
                                                                          child,
                                                                          frame,
                                                                          wasSynchronouslyLoaded) {
                                                                return child;
                                                              }, errorBuilder: (context,
                                                                      exception,
                                                                      stackTrace) {
                                                                return Container(
                                                                  color: Colors
                                                                      .black38,
                                                                );
                                                              })));
                                                    }));
                                          })
                                      : StreamBuilder(
                                          stream: ref
                                              .watch(postControllerProvider)
                                              .userPosts(widget.id, false),
                                          builder: (context,
                                              AsyncSnapshot<
                                                      QuerySnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  color: tabColor,
                                                ),
                                              );
                                            }
                                            if (snapshot.data!.docs.isEmpty) {
                                              return Center(
                                                child:
                                                    Text("No thoughts available"),
                                              );
                                            }
                                            return Expanded(
                                              child: ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  itemCount:
                                                      snapshot.data!.docs.length,
                                                  itemBuilder: (context, index) {
                                                    Post post = Post.fromPost(
                                                        snapshot.data!.docs[index]
                                                            .data());
                                                    return PostCard(
                                                        post: post,
                                                        profile: true);
                                                  }),
                                            );
                                          })
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: visible,
        child: FloatingActionButton(
          onPressed: () => img
              ? addPic(context,false,)
              : Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddThought())),
          shape: const CircleBorder(),
          backgroundColor: tabColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


}
