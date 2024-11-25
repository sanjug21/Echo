
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../common/color.dart';
import '../../../common/message_enum.dart';
import 'display_message_type.dart';




class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type, required this.onLeftSwipe, required this.repliedText, required this.username, required this.replyMessageType
  });
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum replyMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying =repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: (s)=>onLeftSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
            minWidth: 95
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            color: Colors.transparent.withOpacity(.6).withRed(1).withGreen(10).withBlue(10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding:type==MessageEnum.image?const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 5,
                      bottom: 25
                  ):  const EdgeInsets.only(
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

                      DisplayMsg(msg: message, type: type)
                    ],
                  )
                ),
                Positioned(
                  bottom: 1,
                  right: 12,

                  child:
                      Text(date,style: TextStyle(color: Colors.grey,fontSize: 10),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}