import 'package:echo/home/Post/post_Repo/user_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/Widget/snack_bar.dart';
import '../../../common/color.dart';
import '../post_controller/post_controller.dart';
class EditThought extends ConsumerStatefulWidget {
  final Post post;
  const EditThought({super.key,required this.post});

  @override
  ConsumerState<EditThought> createState() => _EditThoughtState();
}

class _EditThoughtState extends ConsumerState<EditThought> {
  bool posting=false;
  bool loading=false;
  TextEditingController thought=TextEditingController();
  void edit()async{
    setState(() {
      loading=true;
      posting=true;
    });
    try{
      String result=await ref.read(postControllerProvider).updatePost(thought.text.trim(), widget.post.postId);
      if(result=="Updated"){
        setState(() {
          loading=false;
        });
        Navigator.pop(context);
        showSnackBar(context, "Thought posted");

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
  void initState() {
    // TODO: implement initState
    super.initState();
    thought.text=widget.post.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit"),
        leading:  IconButton(onPressed: (){
          if(posting==false)Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back,color: posting?Colors.blueGrey:Colors.red,)),
        actions: [
          IconButton(onPressed: (){
            if(posting==false)edit();
          }, icon: Icon(Icons.done,color: posting?Colors.blueGrey:Colors.green,))
        ],
        backgroundColor: backgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.black,
        child: Stack(
          children: [
            TextField(
              controller: thought,
              maxLines: 50,
              cursorColor: tabColor,
              decoration: InputDecoration(
                border: InputBorder.none,


              ),
            ),
            if(loading==true)const LinearProgressIndicator(color: tabColor,)
          ],
        ),
      ),

    );
  }
}
