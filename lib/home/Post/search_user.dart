import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo/common/color.dart';
import 'package:echo/home/Profile/profile_screen.dart';
import 'package:flutter/material.dart';

class SearchUser extends StatefulWidget {
  static const routeName='/search_screen';
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final search=TextEditingController();
  bool showUser=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    search.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: searchBarColor,
        title: TextField(
          controller: search,
          cursorColor: tabColor,
          decoration: const InputDecoration(
            hintText: 'Search users',
            contentPadding:EdgeInsets.all(5),
            focusedBorder:  UnderlineInputBorder(
                borderSide: BorderSide(color: tabColor)
            ),
          ),
          onChanged: (val){
            if(val.trim()==""){
              setState(() {
                showUser=false;
              });
            }else{
              setState(() {
                showUser=true;
              });
            }
          },
        ),
      ),
      body:showUser?Container(color:backgroundColor,height:size.height,child: FutureBuilder(future:FirebaseFirestore.instance.collection('Users').where('Username',isGreaterThanOrEqualTo: search.text).where('Username', isLessThanOrEqualTo:'${search.text}\uf8ff').get(),
           builder:(context,snapshot){
             if(!snapshot.hasData){
               return const Center(child: CircularProgressIndicator(color: appBarColor,),);
             }
             return ListView.builder(
                 itemCount: (snapshot.data! as dynamic).docs.length,
                 itemBuilder: (context,index){
                   return InkWell(
                     onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileScreen(id: (snapshot.data! as dynamic).docs[index]['Uid']))),
                     child: ListTile(
                       leading: CircleAvatar(
                         backgroundColor: Colors.black,
                         backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['ProfilePic']),
                       ),
                       title: Text((snapshot.data! as dynamic).docs[index]['Username']),
                     ),
                   );
                 }
             );
           },

      )):Container(height: size.height,color: backgroundColor,),
    );
  }
}
