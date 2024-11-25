
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import '../../../common/message_enum.dart';

class DisplayMsg extends StatelessWidget {
  final String msg;
  final MessageEnum type;
  const DisplayMsg({super.key, required this.msg, required this.type});

  @override
  Widget build(BuildContext context) {

    return type==MessageEnum.text?Text(
      msg,
      style: const TextStyle(
        fontSize: 15,
      ),
    ):

    CachedNetworkImage(imageUrl: msg,fit: BoxFit.fitWidth,);
  }
}
