import 'package:echo/common/color.dart';
import 'package:flutter/material.dart';
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(child: Text("echo",style: TextStyle(fontSize: 35

      ),),),
    );
  }
}
