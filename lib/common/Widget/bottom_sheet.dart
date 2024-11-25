import 'dart:io';

import 'package:flutter/material.dart';

import '../../home/Post/add_post.dart';
import '../color.dart';
import 'image_picker.dart';
void addPic(BuildContext context,bool profile) => showModalBottomSheet<void>(
  context: context,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25))),
  builder: (BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 200,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select image from:",
              style: TextStyle(fontSize: 23),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                    child: TextButton(
                        onPressed: () => pickImage(context,'gallery', profile),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Gallery',
                              style: TextStyle(
                                  fontSize: 22, color: Colors.white),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              Icons.photo_album_outlined,
                              color: Colors.white,
                            )
                          ],
                        ))),
                SizedBox(
                    child: TextButton(
                        onPressed: () => pickImage(context,'camera', profile),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Camera',
                              style: TextStyle(
                                  fontSize: 22, color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.camera,
                              color: Colors.white,
                            )
                          ],
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  },
);
File? image;
void pickImage(BuildContext context,String path, bool profile) async {
  image = await pickImageFromGallery(context, path);
  Navigator.pop(context);
  Navigator.pushNamed(context, AddPost.routeName,
      arguments: {'image': image, 'profile': profile,});
}

