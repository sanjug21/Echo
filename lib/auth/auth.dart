
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/auth/storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'echo_user.dart';


final authRepoProvider = Provider((ref) => AuthMethod(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthMethod {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const AuthMethod({required this.auth, required this.firestore});

  Future<EchoUser?> getUserData() async {
    var userData =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    EchoUser? user;
    if (userData.data() != null) {
      user = EchoUser.fromMap(userData.data()!);
    }
    return user;
  }
  Stream<EchoUser> getUserStatus(String userId) {
    if(userId=="")userId=auth.currentUser!.uid;
    return firestore
        .collection('Users')
        .doc(userId)
        .snapshots()
        .map((event) => EchoUser.fromMap(event.data()!));
  }
  Future<EchoUser?> getUser(String id) async {
    var userData =
    await firestore.collection('Users').doc(id).get();
    EchoUser? user;
    if (userData.data() != null) {
      user = EchoUser.fromMap(userData.data()!);
    }
    return user;
  }

  Future<String> signUp(
      {required String name,
      required String bio,
      required String phone,
      required String email,
      required String password,
      required File? file,
      required Ref ref}) async {
    String result = 'Some error occurred!';
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = cred.user!.uid;
      String photoURL = await ref
          .read(firebaseStorageProvider)
          .storeFileToFirebase('ProfilePic/$email/$uid', file!);
      EchoUser user = EchoUser(
          name: name,
          uid: cred.user!.uid,
          phone: phone,
          bio: bio,
          profilePic: photoURL,
          email: email,
          isOnline: true,
          );
      await firestore.collection('Users').doc(uid).set(user.toMap());
      result = 'Account created';
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        result = 'You enter a wrong Email';
      } else if (err.code == 'weak-password') {
        result = 'Your password at least of 6 words';
      } else if (err.code == 'email-already-in-use') {
        result = 'Email already registered';
      }
    } catch (err) {
      result = err.toString();
    }

    return result;
  }

  Future<String> login({required String email, required String pass}) async {
    String result = 'Some error occurred!';
    try {
      if (email.isNotEmpty && pass.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: pass);
        result = 'login';
      } else {
        result = 'Please, Enter all the fields.';
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }





  void setUserState(bool isOnline)async{
    await firestore.collection('Users').doc(auth.currentUser!.uid).update(
        {'isOnline': isOnline});
  }
  Future<String> signOut()async{
    String s="";
    try{
      await auth.signOut();
      s="out";
    }catch(e){
      e.toString();
    }
    return s;
  }
  Future<String> updateDetails(String name,String bio,String no)async{
    String res="";
    try{
      await firestore.collection("Users").doc(auth.currentUser!.uid).update({
        'Username':name,
        'PhoneNumber':no,
        'Bio':bio
      });
      res="Updated";

    }catch(e){
      e.toString();
    }
    return res;
  }
  Future<String> updatePic(File file,Ref ref)async{
    String res="";
    try{

      String photoURL = await ref
          .read(firebaseStorageProvider)
          .storeFileToFirebase('ProfilePic/${auth.currentUser!.email}/${auth.currentUser!.uid}', file);
      await firestore.collection("Users").doc(auth.currentUser!.uid).update({
        'ProfilePic':photoURL
      });
      res="Posted";

    }catch(e){
      e.toString();
    }
    return res;
  }
}
