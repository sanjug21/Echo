// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:echo/common/Widget/snack_bar.dart';
import 'package:echo/common/Widget/textfield.dart';
import 'package:echo/common/color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/Widget/image_picker.dart';
import '../../home/welcome.dart';
import '../auth_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const routeName = '/sign-up';
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool isLoading=false;
  File? image;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    bio.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  void signUp() async{
    if(name.text.trim()==""|| bio.text.trim()==""|| phone.text==""|| email.text==""|| password.text.trim()==""||confirmPassword.text.trim()==""){
      showSnackBar(context, "Please fill all the fields");
      return;
    }
    if(image==null){
      showSnackBar(context, "Please select a profile image");
      return;
    }
    if(password.text!=confirmPassword.text){
      showSnackBar(context, "Password doesn't match");
      return;
    }
  setState(() {
    isLoading=true;
  });
  String result=await ref.read(authControllerProvider).signUp(context,name.text.trim(), bio.text.trim(), phone.text, email.text, password.text.trim(), image!);
  if(result=='Account created') {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Welcome()), (route) => false);

  } else {
    showSnackBar(context, result);
    setState(() {
      isLoading=false;
    });
  }
  }

  void pickImage()async{
  image=await pickImageFromGallery(context,'gallery');
  setState(() {

  });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create your account"),
          backgroundColor: appBarColor,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size.height * .88),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Flexible(flex: 1, child: Container()),
                  GestureDetector(
                    onTap:pickImage,
                    child: image!=null? CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: FileImage(image!),
                      radius: 90,
                    ):const CircleAvatar(
                      backgroundImage: AssetImage('image/p2.png'),
                      radius: 90,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextFieldInput(
                      textEditingController: name,
                      hintText: "Enter your name",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldInput(
                      textEditingController: bio,
                      hintText: "Enter your bio",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldInput(
                      textEditingController: phone,
                      hintText: "Enter your phone number",
                      textInputType: TextInputType.phone),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldInput(
                      textEditingController: email,
                      hintText: "Enter your email id",
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldInput(
                    textEditingController: password,
                    hintText: "Enter your password",
                    textInputType: TextInputType.visiblePassword,
                    isPass: true,
                  ),
                  TextFieldInput(
                    textEditingController: confirmPassword,
                    hintText: "Confirm your password",
                    textInputType: TextInputType.visiblePassword,
                    isPass: true,
                  ),
                  Flexible(flex: 3, child: Container()),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: signUp,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                              (states) => appBarColor),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.cyan,
                                ),
                              )
                            : const Text(
                                "Create Account",
                                style: TextStyle(color: Colors.white,fontSize: 18),
                              )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
