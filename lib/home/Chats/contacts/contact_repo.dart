
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/echo_user.dart';

final contactRepoProvider=Provider((ref) => ContactRepo(firestore: FirebaseFirestore.instance));

class ContactRepo{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth=FirebaseAuth.instance;

  ContactRepo({required this.firestore});
  Future<List<dynamic>> getContacts()async{
    String mine=auth.currentUser!.uid;
    List<Contact> contacts=[];
    List<dynamic> finalList=[];
    try{
      if(await FlutterContacts.requestPermission()){
        contacts=await FlutterContacts.getContacts(withProperties: true);
      }

      var userCollection=await firestore.collection('Users').get();

      List<String> con=[];
      for(var contact in contacts){
        try{
          String curr = contact.phones[0].number
              .replaceAll(' ', '')
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('-', '');
          if (curr[0] == '0') curr = curr.substring(1);
          if (curr.substring(0, 3) == "+91") curr = curr.substring(3);
          if(!con.contains(curr))con.add(curr);
        }catch(e){
          continue;
        }
      }

      for(var document in userCollection.docs){
        var userData=EchoUser.fromMap(document.data());
        //print(userData.name);
        if(con.contains(userData.phone) && userData.uid!=mine) {
          finalList.add(userData);
        }
      }


    }catch(e){
      debugPrint(e.toString());
      e.toString();
    }

  // print(finalList);

    return finalList;
  }
  Future<List<String>>allContacts()async{
    List<Contact> contacts=[];
    List<String> con=[];
    try{
    if(await FlutterContacts.requestPermission()){
      contacts=await FlutterContacts.getContacts(withProperties: true);
    }

    for(var contact in contacts){
      try{
        String curr = contact.phones[0].number
            .replaceAll(' ', '')
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll('-', '');
        if (curr[0] == '0') curr = curr.substring(1);
        if (curr.substring(0, 3) == "+91") curr = curr.substring(3);
        if(!con.contains(curr))con.add(curr);
      }catch(e){
        continue;
      }
    }}
    catch(e){
      //
    }
    con.add(auth.currentUser!.phoneNumber!);
    return con;
  }


}
