
import 'dart:io';

import 'package:echo/home/Profile/view_post.dart';
import 'package:echo/home/welcome.dart';
import 'package:flutter/material.dart';

import 'auth/screens/login_screen.dart';
import 'auth/screens/signup_screen.dart';
import 'home/Chats/user_chats.dart';
import 'home/Chats/contacts/contact_screen.dart';
import 'home/Post/add_post.dart';
import 'home/Post/post_Repo/user_posts.dart';
import 'home/Post/search_user.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch(settings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const LoginScreen());
    case SignupScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SignupScreen());
    case Welcome.routeName:
      return MaterialPageRoute(
          builder: (context) => const Welcome());
    case ContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const ContactScreen());
    case SearchUser.routeName:
      return MaterialPageRoute(
          builder: (context) => const SearchUser());
    case ChatScreen.routeName:
      final argument=settings.arguments as Map<String,dynamic>;
      return MaterialPageRoute(

          builder: (context) =>  ChatScreen(currUser: argument['id'], name: argument['name'],pic: argument['pic'],));
    case AddPost.routeName:
      final argument=settings.arguments as Map<String,dynamic>;
      File file=argument['image'];
      bool profile=argument['profile'];

      return MaterialPageRoute(
          builder: (context) =>AddPost(file: file, profile: profile,));
      case ViewPost.routeName:
      final argument=settings.arguments as Post;
      
      return MaterialPageRoute(
          builder: (context) =>ViewPost(post: argument));
  default:
   return MaterialPageRoute(
            builder: (context) => const Scaffold(body: Text("This page doesn't exist"), ),
          );
  }

}