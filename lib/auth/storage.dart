import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


// class StorageMethod{
// final FirebaseAuth auth=FirebaseAuth.instance;
// final FirebaseStorage storage=FirebaseStorage.instance;
//
// Future<String> uploadImage(String childName,File file,bool isPost) async {
//   String uid=auth.currentUser!.uid;
//   Reference ref=storage.ref().child('profilePic/$uid').child(uid);
//   if(isPost){
//     String id=const Uuid().v1();
//     ref=ref.child(id);
//   }
//   UploadTask uploadTask=ref.putFile(file);
//   TaskSnapshot snapshot=await uploadTask;
//   String downloadURL= await snapshot.ref.getDownloadURL();
//   return downloadURL;
// }
//}


final firebaseStorageProvider=Provider(
        (ref) => StorageMethod(storage: FirebaseStorage.instance));

class StorageMethod{
  final FirebaseStorage storage;


  StorageMethod({required this.storage});

  Future<String> storeFileToFirebase(String ref,File file) async {
    UploadTask uploadTask=storage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot=await uploadTask;
    String downloadURL= await snapshot.ref.getDownloadURL();
    return downloadURL;
  }


}