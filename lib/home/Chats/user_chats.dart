
// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/common/Widget/image_picker.dart';
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
    var size = MediaQuery
        .of(context)
        .size;
    final keyboardHeight = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: StreamBuilder(
                stream: ref.read(authControllerProvider).getUserStatus(
                    widget.currUser),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (
                                  context) =>
                                  DisplayImg(img: snapshot.data!.profilePic,
                                      name: snapshot.data!.name))),
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: ClipOval(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.profilePic,
                                  fit: BoxFit.cover,),
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
                              width: size.width * .45,
                              child: GestureDetector(
                                onTap: () =>
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileScreen(
                                                id: snapshot.data!.uid))),
                                child: Text(
                                  snapshot.data!.name,
                                  style: const TextStyle(fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ),
                            if (snapshot.data!.isOnline)const Text(
                              "online", style: TextStyle(
                                fontSize: 12, color: Colors.greenAccent),)
                          ],
                        ),
                        const SizedBox(width: 10,),


                      ],
                    );
                  }
                  return Container();
                }),
            actions: [
              MenuAnchor(
                  style: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Colors.transparent.withOpacity(.8)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ))
                  ),

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
                      icon: const Icon(
                        Icons.more_vert_rounded, color: Colors.white,),
                    );
                  },
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () async {
                        backgroundImage =
                        await pickImageFromGallery(context, "gallery");
                        setState(() {

                        });
                      },
                      child: Text("Change Wallpaper"),),
                    MenuItemButton(
                      onPressed: () {
                        setState(() {
                          backgroundImage = null;
                        });
                      },
                      child: Text("Remove wallpaper"),
                    )
                  ]),

            ],

          ),


          body: Container(


            decoration: BoxDecoration(
              color: Colors.white,

              image: DecorationImage(
                image: backgroundImage == null
                    ? AssetImage("image/2nd.png")
                    : FileImage(backgroundImage!),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [

                Flexible(child: ChatList(widget.currUser), flex: 1,),

                AnimatedPadding(
                  padding: EdgeInsets.only(bottom: keyboardHeight),
                  duration: const Duration(milliseconds: 01),
                  curve: Curves.easeOut,
                  child: ChatTextField(receiverId: widget.currUser,),
                ),


              ],
            ),
          )

      ),
    );
  } // ignore_for_file: deprecated_member_use
}
