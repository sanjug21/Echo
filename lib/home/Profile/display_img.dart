import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/common/color.dart';
import 'package:flutter/material.dart';
class DisplayImg extends StatelessWidget {
  final String img;
  final String name;
  const DisplayImg({super.key,required this.img,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: appBarColor,
      ),
      body: ConstrainedBox(

          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),

        child: Center(child: Container(color:backgroundColor,child: CachedNetworkImage(imageUrl: img))),
      ),
    );
  }
}
