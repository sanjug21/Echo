
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/common/color.dart';
import 'package:echo/home/Chats/widgets/chat_list.dart';
import 'package:echo/home/Chats/widgets/chat_text_field.dart';
import 'package:echo/home/Profile/display_img.dart';
import 'package:echo/home/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/chat-screen';
  final String currUser;
  final String name;
  final String pic;

  const ChatScreen({super.key, required this.currUser,required this.name,required this.pic});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder(
            stream: ref.read(authControllerProvider).getUserStatus(widget.currUser),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Container();
              // }
              if(snapshot.hasData){
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () =>Navigator.push(context,MaterialPageRoute(builder: (context)=>DisplayImg(img: snapshot.data!.profilePic, name: snapshot.data!.name))),
                    child:  SizedBox(
                      width: 45,
                      height: 45,
                      child: ClipOval(
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: CachedNetworkImage(imageUrl:snapshot.data!.profilePic,fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:size.width*.45,
                        child: GestureDetector(
                          onTap:()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileScreen(id: snapshot.data!.uid))),
                          child: Text(
                             snapshot.data!.name,
                            style:const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ),
                      if (snapshot.data!.isOnline)const Text("online",style: TextStyle(fontSize: 12,color: Colors.greenAccent),)
                    ],
                  ),
                  const SizedBox(width: 10,),


                ],
              );}
              return Container();
            }),
        actions: [
          IconButton(
            onPressed: () {},
            icon:  Icon(
              Icons.more_vert,
              color:Colors.white,
              size: size.width*.05,
            ),
          ),
        ],
      ),
        
      body:  Container(
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage==null?AssetImage("image/back.jpg"):FileImage(backgroundImage!),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [

            Flexible(
                child: ChatList(widget.currUser)),
          ChatTextField( receiverId: widget.currUser,)

          ],
        ),
      )
    );
  }
}
