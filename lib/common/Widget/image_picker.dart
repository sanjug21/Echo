import 'dart:io';

import 'package:echo/common/Widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery(BuildContext context,String path)async{
  File? image;
  try{
    switch(path){
      case 'gallery':
        final pickedImage =await ImagePicker().pickImage(source: ImageSource.gallery);

        if(pickedImage!=null){
          image=File(pickedImage.path);}
      case 'camera' :
        final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

        if(pickedImage!=null){
          image=File(pickedImage.path);}
      default :


  }}catch(e){
    // ignore: use_build_context_synchronously
    showSnackBar(context, e.toString());
  }

  return image;
}

// Future<File?> pickVideoFromGallery(BuildContext context)async{
//   File? video;
//   try{
//     final pickedVideo=await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if(pickedVideo!=null){
//       video=File(pickedVideo.path);
//     }
//   }catch(e){
//     // ignore: use_build_context_synchronously
//     showSnackBar(context, e.toString());
//   }
//
//   return video;
// }
