
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';
import 'echo_user.dart';

final authControllerProvider=Provider((ref) {
final authMethod=ref.watch(authRepoProvider);
return AuthController(authMethod: authMethod,ref: ref);
});

final userDataProvider=FutureProvider((ref) {
final authController=ref.watch(authControllerProvider);
return authController.getUserData();
});


class AuthController{
  final AuthMethod authMethod;
  final Ref ref;

  AuthController({required this.authMethod, required this.ref});
  Future<EchoUser?> getUserData()async{
    EchoUser? user= await authMethod.getUserData();
    return user;
  }
  Future<EchoUser?> getUser(String id)async{
    EchoUser? user= await authMethod.getUserData();
    return user;
  }
  Stream<EchoUser> getUserStatus(String userId){
    return authMethod.getUserStatus(userId);
  }


Future<String> signUp(BuildContext context,String name,String bio,String phone,String email,String password,File image){
  return authMethod.signUp(name: name, bio: bio, phone: phone, email: email, password: password, file: image,ref: ref);
  }
  Future<String>login(String email,String pass){
  return authMethod.login(email: email, pass: pass);
  }
  Future<String> signOut()async{
    return await authMethod.signOut();
  }

  void setUserState(bool isOnline)async{
    authMethod.setUserState(isOnline);
  }
  Future<String> updateDetails(String name,String bio,String no){
    return authMethod.updateDetails(name, bio, no);
  }
  Future<String> updatePic(File file){
    return authMethod.updatePic(file, ref);
  }


}