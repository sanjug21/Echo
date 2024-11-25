// ignore_for_file: use_build_context_synchronously

import 'dart:io';


import 'package:echo/auth/auth_controller.dart';
import 'package:echo/common/Widget/snack_bar.dart';
import 'package:echo/common/color.dart';
import 'package:echo/home/Post/post_controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class AddPost extends ConsumerStatefulWidget {
  static const routeName = '/add-post';
  final File file;
  final bool profile;

  const AddPost({super.key,required this.file,required this.profile});

  @override
  ConsumerState<AddPost> createState() => _AddPostState();
}

class _AddPostState extends ConsumerState<AddPost> {
  bool loading=false;
  bool posting=false;
  void postImage(File file)async{
    setState(() {
      loading=true;
      posting=true;
    });
    try{
      String result=widget.profile?await ref.read(authControllerProvider).updatePic(file):await ref.read(postControllerProvider).uploadPost(file,"");
      if(result=="Posted"){
        setState(() {
          loading=false;
        });
        Navigator.pop(context);
        widget.profile?showSnackBar(context, "Profile picture updated"):showSnackBar(context, "Image posted");

      }
    }catch(e){
      showSnackBar(context, e.toString());
    }
    setState(() {
      loading=false;
      posting=false;
    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
                  title: widget.profile?Text('Change your profile picture'):Text("Post image"),
                  actions: [
                    IconButton(onPressed: (){
                      if(posting==false)postImage(widget.file);
                    }, icon: Icon(Icons.done,color: posting?Colors.blueGrey:Colors.green,))
                  ],
          leading:  IconButton(onPressed: (){
            if(posting==false)Navigator.pop(context);
          }, icon:Icon(Icons.arrow_back,color: posting?Colors.blueGrey:Colors.red,)),
          backgroundColor: backgroundColor,
                ),
                body: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [Center(
                      child:SizedBox(
                        child: Image(
                          image: FileImage(widget.file),
                        ),
                      )
                    ),
                    if(loading==true)const LinearProgressIndicator(color: tabColor,)

                    ]
                  ),
                ),
              );
  }
}
