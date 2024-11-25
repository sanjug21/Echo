
import 'package:echo/common/Widget/snack_bar.dart';
import 'package:echo/common/color.dart';
import 'package:echo/home/Post/post_controller/post_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Post/post_Repo/user_posts.dart';

class ViewPost extends ConsumerWidget {
  static const routeName = '/view_post';
  final Post post;

  const ViewPost({super.key, required this.post,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Map<int, String> map = {
    //   1: "Jan",
    //   2: "Feb",
    //   3: "Mar",
    //   4: "Apr",
    //   5: "May",
    //   6: "Jun",
    //   7: "Jul",
    //   8: "Aug",
    //   9: "Sep",
    //   10: "Oct",
    //   11: "Nov",
    //   12: "Dec"
    // };
    // DateTime date = post.datePublished.toDate();
    var curr = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(post.username,style: TextStyle(overflow: TextOverflow.ellipsis),),
        backgroundColor: backgroundColor,
        actions: [
          Icon(Icons.favorite,color: Colors.red,),
          SizedBox(width: 5,),
          Text('${post.likes.length}',style: TextStyle(fontSize: 20),),
          if (post.uid == curr)
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
                                        post.postId, true);
                                    if (ans == "Deleted") {
                                      Navigator.pop(context);
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

      body:
      Container(
        color: Colors.black54,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Image.network(post.postUrl,
              // fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
