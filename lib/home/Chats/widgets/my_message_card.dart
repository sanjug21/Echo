
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../common/color.dart';
import '../../../common/message_enum.dart';
import 'display_message_type.dart';


class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
final MessageEnum type;
final VoidCallback onLeftSwipe;
final String repliedText;
final String username;
final MessageEnum replyMessageType;
final bool isSeen;
  const MyMessageCard({super.key, required this.message, required this.date,required this.type, required this.onLeftSwipe, required this.username, required this.replyMessageType, required this.repliedText, required this.isSeen});

  @override
  Widget build(BuildContext context) {
    final isReplying =repliedText.isNotEmpty;
    return SwipeTo(
     onLeftSwipe:  (s)=>onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,

            minWidth: 95,

          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            color: Colors.transparent.withOpacity(.6).withGreen(10).withBlue(10).withRed(1),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Stack(
              children: [
                Container(
                  padding:type==MessageEnum.image?const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 25
                  ): const EdgeInsets.only(
                      top: 10,bottom: 20,left: 20,right: 20
                  ),
                  child: Column(
                    children: [
                      if(isReplying)...[
                        Text(username,style: const TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 3),
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  5,
                                ),
                              ),
                            ),


                            child: DisplayMsg(msg: repliedText, type: replyMessageType)),
                        const SizedBox(height: 8),
                        
                      ],

                      DisplayMsg(msg: message, type: type),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 1,
                  right: 12,

                  child: Row(
                    children: [
                      Text(date,style: TextStyle(color: Colors.grey,fontSize: 10),),
                      SizedBox(width: 5,),
                      Icon(

                        isSeen?Icons.check_circle_outline_rounded:Icons.check_circle_outline,
                        size: 12,
                        color: isSeen?tabColor:Colors.white,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}