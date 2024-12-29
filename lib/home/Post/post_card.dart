import 'package:echo/common/color.dart';
import 'package:echo/home/Post/post_Repo/edit_thought.dart';
import 'package:echo/home/Post/post_Repo/user_posts.dart';
import 'package:echo/home/Post/post_controller/post_controller.dart';
import 'package:echo/home/Profile/profile_screen.dart';
import 'package:echo/home/Profile/view_post.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/Widget/snack_bar.dart';
import '../../common/like_animation.dart';
import '../../common/months.dart';
import '../Profile/display_img.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  final bool profile;
  const PostCard({super.key, required this.post, required this.profile});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool isLikeAnimating=false;

  void likePost() async{
    ref.read(postControllerProvider).likePost(widget.post.uid,widget.post.postId, widget.post.likes, widget.post.isImage);
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var id=FirebaseAuth.instance.currentUser!.uid;
    bool curr =id == widget.post.uid
        ? true
        : false;
    DateTime date = widget.post.datePublished.toDate();
    return Container(

      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DisplayImg(img: widget.post.profImage,name: widget.post.username,))),
                      child: CircleAvatar(
                        backgroundColor: Colors.black12,
                        foregroundColor: Colors.black12,
                        backgroundImage: NetworkImage(widget.post.profImage),
                        radius: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    InkWell(
                        onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(id: widget.post.uid)))
                            },
                        child: Text(
                          widget.post.username,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 21),
                        ))
                  ],
                ),

                if (curr && widget.profile && !widget.post.isImage)
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
                          icon: const Icon(Icons.more_vert_rounded),
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditThought(post: widget.post))),
                          child: Text("Edit"),
                        ),
                        MenuItemButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Center(
                                        child: Text(
                                      "Do you want to delete this post",
                                      style: TextStyle(fontSize: 15),
                                    )),
                                    actions: [
                                      Center(
                                          child: ElevatedButton(
                                        onPressed: () async {
                                          String ans = await ref
                                              .read(postControllerProvider)
                                              .deletePost(
                                                  widget.post.postId, false);
                                          if (ans == "Deleted") {
                                            Navigator.pop(context);
                                            showSnackBar(
                                                context, "Post deleted");
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                    ],
                                  )),
                          child: Text("Delete"),
                        )
                      ])
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: !widget.post.isImage ? 10 : 300,
                minWidth: double.infinity),

            child: !widget.post.isImage
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    color:postCardBg,
                    child: Text(
                      widget.post.description,
                      style: TextStyle(fontSize: 20),
                    ))
                : GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, ViewPost.routeName,
                        arguments: widget.post),
                    onDoubleTap: (){
                      if(!widget.post.likes.contains(id))likePost();
                      setState(() {
                        isLikeAnimating=true;
                      });
                    },
                    child: Container(
                      color: postCardBg,
                      child: Stack(
                        alignment: Alignment.center,
                          children: [
                        Center(
                          child: Container(
                            height: size.height * 0.35,
                            color:postCardBg,
                            child: Image.network(
                              widget.post.postUrl,
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                                return child;
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: tabColor,
                                  ),
                                );
                              },
                              errorBuilder: (context, exception, stackTrace) {
                                return Center(
                                  child: Text("check your internet connection"),
                                );
                              },
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration:  const Duration(milliseconds: 400),
                          opacity: isLikeAnimating?1:0,
                          child: LikeAnimation(
                            duration: const Duration(milliseconds: 400),
                            isAnimating: isLikeAnimating,
                            onEnd: (){
                              setState(() {
                                isLikeAnimating=false;
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 130,
                            ),

                          ),
                        )

                      ]),
                    ),
                  ),
          ),
          Container(
            color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        likePost();
                       if(!widget.post.likes.contains(id)){
                         setState(() {
                           isLikeAnimating=true;
                         });
                       }
                      },
                      icon: widget.post.likes
                              .contains(id)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 25,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 25,
                            ),
                    ),
                    Text(
                      '${widget.post.likes.length} likes',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                Text('${date.day} ${map[date.month]}, ${date.year}',
                    style: TextStyle(fontSize: 15))
              ],
            ),
          )
        ],
      ),
    );
  }
}
