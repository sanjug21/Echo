import 'package:echo/common/color.dart';
import 'package:flutter/material.dart';

class LoginWeb extends StatelessWidget {
  const LoginWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(height:100,color:Colors.red,child: Text("data"),),
          Column(
            children: [
              TextField(),
              TextField()
            ],
          )
        ],
      ),
      backgroundColor: backgroundColor,);
  }
}

