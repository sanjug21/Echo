// ignore_for_file: use_build_context_synchronously

import 'package:echo/auth/screens/signup_screen.dart';
import 'package:echo/common/Widget/snack_bar.dart';
import 'package:echo/common/Widget/textfield.dart';
import 'package:echo/common/color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/welcome.dart';
import '../auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
static const routeName="/login-screen";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();
  bool isLoading=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }
  void logIn()async{
    setState(() {
      isLoading=true;
    });
    String result=await ref.read(authControllerProvider).login(email.text.trim(), password.text.trim());
    if(result=='login') {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Welcome()), (route) => false);
      // Navigator.pushNamed(context,Welcome.routeName );
    } else {
      showSnackBar(context, result);
      setState(() {
        isLoading=false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text("Please login to continue" ),
        backgroundColor: appBarColor,
      ),
        body: Padding(

          padding: const EdgeInsets.all(10.0),
          child: Column(

            children: [
              const SizedBox(height: 10,),
              TextFieldInput(textEditingController: email, hintText: "Enter your email", textInputType: TextInputType.emailAddress,),
              const SizedBox(height: 10,),
              TextFieldInput(textEditingController: password, hintText: "Enter your password", textInputType: TextInputType.text,isPass: true,),
              const SizedBox(height: 40,),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: logIn,
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
                      "login",
                       style: TextStyle(color: Colors.white,fontSize: 20),
                    )),
              ),

              Flexible(flex: 1,child: Container(),),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  ",style: TextStyle(fontSize: 16),),
                   GestureDetector(onTap:(){Navigator.pushNamed(context, SignupScreen.routeName);},child: const Text("Sign up",style: TextStyle(fontSize: 16),)),

                ],
              )
            ]
        ),
        ),
    );
  }
}
