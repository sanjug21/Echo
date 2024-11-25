import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/home/Post/post_Repo/user_posts.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/echo_user.dart';
import '../../../auth/storage.dart';

final postRepoProvider=Provider((ref) => PostRepo(firestore: FirebaseFirestore.instance,auth: FirebaseAuth.instance));
class PostRepo{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  PostRepo({required this.firestore,required this.auth});
  Future<String> uploadPost({required File? file,required String thought, required Ref ref}) async {
    String res = "Some error occurred";
    try {
      var userData =
      await firestore.collection('Users').doc(auth.currentUser?.uid).get();
      EchoUser? user = EchoUser.fromMap(userData.data()!);
      String postId = const Uuid().v1();
      String postUrl = await ref
          .read(firebaseStorageProvider)
          .storeFileToFirebase('Posts/${user.uid}/$postId', file!);

      Post post = Post(
          description: thought,
          phone: user.phone,
          uid: user.uid,
          username: user.name,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          postId: postId,
          profImage: user.profilePic,
          likes: [],
          isImage: true
      );

      firestore.collection('Posts').doc(postId).set(post.toPost());
      firestore.collection('UserPosts').doc(auth.currentUser!.uid).collection("posts").doc(postId).set(post.toPost());
      res = "Posted";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  Future<String> uploadThought({required String thought, required Ref ref}) async {
    String res = "Some error occurred";
    try {
      var userData =
      await firestore.collection('Users').doc(auth.currentUser?.uid).get();
      EchoUser? user = EchoUser.fromMap(userData.data()!);
      String postId = const Uuid().v1();

      Post post = Post(
          description: thought,
          phone: user.phone,
          uid: user.uid,
          username: user.name,
          datePublished: DateTime.now(),
          postUrl: "",
          postId: postId,
          profImage: user.profilePic,
          likes: [],
          isImage: false
      );

      firestore.collection('Posts').doc(postId).set(post.toPost());
      firestore.collection('UserPosts').doc(auth.currentUser!.uid).collection("thoughts").doc(postId).set(post.toPost());
      res = "Posted";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts(){
    return firestore.collection('Posts').orderBy('datePublished',descending: true).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> userPosts(String id,bool img){
    if(id=="")id=auth.currentUser!.uid;
    if(img==false)return firestore.collection('UserPosts').doc(id).collection("thoughts").orderBy('datePublished',descending: true).snapshots();
    return firestore.collection('UserPosts').doc(id).collection("posts").orderBy('datePublished',descending: true).snapshots();
  }
  Future<String> deletePost(String id,bool img)async{
    String res="";

    try{
      await firestore.collection('Posts').doc(id).delete();
      img?await firestore.collection('UserPosts').doc(auth.currentUser!.uid).collection('posts').doc(id).delete():
      await firestore.collection('UserPosts').doc(auth.currentUser!.uid).collection("thoughts").doc(id).delete();
      res="Deleted";

    }catch(e){
      e.toString();
    }
    return res;
  }
  Future<String>updatePost(String des,String id)async{
    String res="";
    try{
      await firestore.collection('Posts').doc(id).update(
        {
          'description':des,
          'datePublished':DateTime.now()
        }
      );
      await firestore.collection('UserPosts').doc(auth.currentUser!.uid).collection('thoughts').doc(id).update({
        'description':des,
        'datePublished':DateTime.now()
      });

      res="Updated";
    }catch(e){
      e.toString();
    }
    return res;
  }

  Future<void>likePost(String id,String postId,List likes,bool isImage)async{
    String uid=auth.currentUser!.uid;

    try{
      if(likes.contains(uid)){
        await firestore.collection('Posts').doc(postId).update(
            {'likes': FieldValue.arrayRemove([uid])}
        );
        isImage?await firestore.collection('UserPosts').doc(id).collection('posts').doc(postId).update(
            {'likes': FieldValue.arrayRemove([uid])}
        ):
        await firestore.collection('UserPosts').doc(id).collection("thoughts").doc(postId).update(
            {'likes': FieldValue.arrayRemove([uid])}
        );
      }else{
        await firestore.collection('Posts').doc(postId).update(
            {'likes': FieldValue.arrayUnion([uid])}
        );
        isImage?await firestore.collection('UserPosts').doc(id).collection('posts').doc(postId).update(
            {'likes': FieldValue.arrayUnion([uid])}
        ):
        await firestore.collection('UserPosts').doc(id).collection("thoughts").doc(postId).update(
            {'likes': FieldValue.arrayUnion([uid])});
      }
    }catch(e){
      e.toString();
    }

  }

}