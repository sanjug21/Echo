
import 'dart:io';

import 'package:echo/common/color.dart';
import 'package:echo/common/message_enum.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/Widget/image_picker.dart';
import '../controller/chatController.dart';


class ChatTextField extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatTextField({super.key,required this.receiverId});

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  bool sendButton=false;
  bool disableIcons=false;

  final message=TextEditingController();

  // bool isRecorderInit=false;
  //  bool isRecording=false;
  bool isShowEmoji=false;
  FocusNode focusNode=FocusNode();
  bool isShowEmojiContainer = false;

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {

    if(focusNode.hasFocus) {
      hideKeyboard();
      showEmojiContainer();
      return;
    }
    if (isShowEmojiContainer ) {
           hideEmojiContainer();
    }else{
      showEmojiContainer();
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    message.dispose();

    // isRecorderInit=false;
  }
void sendTextMsg()async{
    if(sendButton){
      sendButton=false;
      ref.read(chatControllerProvider).sendTextMessage(context, message.text.trim(), widget.receiverId);
      message.text="";
      setState(() {
        disableIcons=false;
      });
    }
}
void sendFileMsg(bool img)async{
    File? file;
    if(img) {
      file= await pickImageFromGallery(context, "gallery");
    } else {}
    if(file!=null){
      ref.read(chatControllerProvider).sendFileMessage(context, file, widget.receiverId, MessageEnum.image);
    }
}
  @override
  Widget build(BuildContext context) {

    return
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(

                      child: TextFormField(
                        focusNode: focusNode,
                        controller: message,
                        minLines: 1,
                        maxLines: 5,

                        onChanged: (val){
                          if(val.isNotEmpty) {
                            setState(() {
                              sendButton = true;
                              disableIcons=true;
                            });
                          }else{
                            setState(() {
                              sendButton=false;
                              disableIcons=false;
                            });
                          }
                        },

                        cursorColor: tabColor,

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          prefixIcon: IconButton(onPressed:toggleEmojiKeyboardContainer,icon:const Icon(Icons.emoji_emotions_sharp),splashRadius: 5,),
                          suffixIcon: disableIcons?IconButton(onPressed: sendTextMsg, icon: Icon(Icons.send_rounded)):SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(onPressed:(){},icon:const Icon(Icons.attach_file_sharp),splashRadius: 5,),
                                IconButton(onPressed:()=>sendFileMsg(true),icon:const Icon(Icons.camera_alt_outlined),splashRadius: 5,),
                              ],),
                          ),
                          hintText: "Write a message",
                          focusedBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(color: tabColor)
                          ),
                          // fillColor: Colors.white10,

                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(
                              color: tabColor
                            ),),

                        ),
                      ),

                    ),
                  ),


                ],
              ),
              isShowEmojiContainer &&!focusNode.hasFocus
                  ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  textEditingController: message,
                  onEmojiSelected: ((category, emoji) {
                    setState(() {


                    });

                    if (!sendButton) {
                      setState(() {
                        sendButton = true;
                      });
                    }
                  }),
                ),
              )
                  : const SizedBox(),
            ],
          ),
        );
  }
}
