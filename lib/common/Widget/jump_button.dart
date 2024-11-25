
import 'package:flutter/material.dart';

import '../color.dart';

class JumpButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final IconData? icon;
  final String routeName;
  final String text;

  const JumpButton(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      this.icon,
      required this.routeName,
      required this.text});

  @override
  Widget build(BuildContext context) {
    // var size=MediaQuery.of(context).size;
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          // if(size.width>450) {
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          // } else {
            Navigator.pushNamed(context, routeName);
          // }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: tabColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 19,
              ),
            ),
            if (icon != null)
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    icon,
                    color: Colors.black87,
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
