import 'package:flutter/material.dart';

import '../color.dart';
class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({super.key, required this.textEditingController,  this.isPass=false, required this.hintText, required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      cursorColor: tabColor,
      decoration: InputDecoration(

        hintText: hintText,
        contentPadding:const EdgeInsets.all(5),
        focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: tabColor)
        ),


      ),

      obscureText: isPass,
      keyboardType:  textInputType,
      obscuringCharacter: '*',
    );
  }
}
