import 'package:echo/auth/auth_controller.dart';
import 'package:echo/common/Widget/snack_bar.dart';
import 'package:echo/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditDetails extends ConsumerStatefulWidget {
  final String name;
  final String no;
  final String bio;
  const EditDetails( {super.key,required this.name,required this.no, required this.bio,});

  @override
  ConsumerState<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends ConsumerState<EditDetails> {
TextEditingController nameC= TextEditingController();
TextEditingController noC= TextEditingController();
TextEditingController bioC= TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameC.text=widget.name;
    bioC.text=widget.bio;
    noC.text=widget.no;
  }
  void update()async{
  String res=await ref.read(authControllerProvider).updateDetails(nameC.text.trim(), bioC.text.trim(), noC.text.trim());
  if(res=="Updated"){
    Navigator.pop(context);
    showSnackBar(context, "Details updated");
  }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Update your details"),
        backgroundColor: appBarColor,


      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Change your name"),
            TextField(
              cursorColor: tabColor,
              decoration: InputDecoration(
                focusedBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(color: tabColor)
                ),

              ),
              controller: nameC,
            ),
            SizedBox(height: 15,),
            Text("Change your bio"),

            TextField(
              controller: bioC,
              cursorColor: tabColor,
              decoration: InputDecoration(
                focusedBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(color: tabColor)
                ),

              ),
            ),
            SizedBox(height: 15,),
            Text("Change your phone number"),
            TextField(
              controller: noC,
              cursorColor: tabColor,
              decoration: InputDecoration(
                focusedBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(color: tabColor)
                ),

              ),
            ),
            Flexible(
              child: Container(),
            ),
            SizedBox(width:double.infinity,child: ElevatedButton(onPressed:update,style: ElevatedButton.styleFrom(backgroundColor: appBarColor,), child: Text("Update",style: TextStyle(color: Colors.white,fontSize: 20),),))
          ],
        ),
      ),
    );
  }
}
