
import 'package:flutter/material.dart';

import '../../common/Widget/jump_button.dart';
import '../../common/color.dart';
import 'login_screen.dart';


class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width*95,
                child:const Center(
                  child: Text(
                    'Welcome to Echo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 35,),
               const JumpButton(width: 180, height: 50, color:appBarColor, routeName: LoginScreen.routeName, text: "Let's start",icon: Icons.arrow_forward_outlined,),
                    ],
                  ),),
              ),
          );

  }
}
