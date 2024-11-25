
import 'package:echo/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/Widget/snack_bar.dart';
import '../post_controller/post_controller.dart';
class AddThought extends ConsumerStatefulWidget {
  const AddThought({super.key});

  @override
  ConsumerState<AddThought> createState() => _AddThoughtState();
}

class _AddThoughtState extends ConsumerState<AddThought> {
  bool posting=false;
  bool loading=false;
  TextEditingController thought=TextEditingController();
  void addThought()async{

    setState(() {
      loading=true;
      posting=true;
    });
    try{
      String result=await ref.read(postControllerProvider).uploadThought(thought.text.trim());
    if(result=="Posted"){
    setState(() {
    loading=false;
    });
    Navigator.pop(context);showSnackBar(context, "Thought posted");

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

   // var size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        title: Text("Post thought"),
        leading:  IconButton(onPressed: (){
          if(posting==false)Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back,color: posting?Colors.blueGrey:Colors.red,)),
        actions: [
          IconButton(onPressed: (){
             if(posting==false)addThought();
          }, icon: Icon(Icons.done,color: posting?Colors.blueGrey:Colors.green,))
        ],
        backgroundColor: backgroundColor,
      ),
      body: Container(
        color: Colors.black,
        child: Padding(padding: EdgeInsets.all(8),
            child: Stack(
              children: [
                TextField(
                  controller: thought,
                  maxLines: 100,
                  cursorColor: tabColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "What's on your mind, write here",

                  ),
                ),
                if(loading==true)const LinearProgressIndicator(color: tabColor,)
              ],
            ),
          ),
      ),
      // body: Container(
      //   color: Colors.black,
      //   child: Stack(
      //     children: [
      //       TextField(
      //         controller: thought,
      //         maxLines: 50,
      //         cursorColor: tabColor,
      //         decoration: InputDecoration(
      //           border: InputBorder.none,
      //           hintText: "What's on your mind, write here",
      //
      //         ),
      //       ),
      //       if(loading==true)const LinearProgressIndicator(color: tabColor,)
      //     ],
      //   ),
      // ),
    );
  }
}
