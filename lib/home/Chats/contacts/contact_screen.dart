import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo/common/Widget/error_screen.dart';
import 'package:echo/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/echo_user.dart';
import '../user_chats.dart';
import 'contact_controller.dart';

class ContactScreen extends ConsumerStatefulWidget {
  static const routeName='/contact-screen';
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select contact',
          style: TextStyle(color:Colors.white),
        ),
        centerTitle: false,
        backgroundColor: appBarColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              )),
        ],
      ),

      body: ref.watch(getContactProvider).when(
          data: (contactList) => Container(
            color: backgroundColor,
            child: ListView.builder(

              padding: const EdgeInsets.all(8),
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final EchoUser contact = contactList[index];
                return Column(
                  children: [
                    SizedBox(

                      height: 60,
                      child: ListTile(

                        visualDensity:const VisualDensity(vertical: -4),
                        splashColor: appBarColor,
                        onTap: ()=>Navigator.popAndPushNamed(context, ChatScreen.routeName,arguments: {'id':contact.uid,'name':contact.name,'pic':contact.profilePic}),
                        title: Text(
                          contact.name.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          contact.phone.toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                        leading: ClipOval(
                           child: AspectRatio(
                             aspectRatio: 1.0,
                             child: CachedNetworkImage(imageUrl: contact.profilePic,width: 50,
                               height: 50,fit: BoxFit.cover,),
                           ),
                          ),
                        //  leading: CircleAvatar(
                        //   backgroundColor: Colors.black87,
                        //   // backgroundImage: NetworkImage(contact.profilePic),
                        //   radius: 25,
                        //    child: CachedNetworkImage(imageUrl: contact.profilePic,fit: BoxFit.cover,),
                        // ),

                      ),
                    ),
                    const Divider(color: appBarColor,)
                  ],
                );
              },
            ),
          ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => Container(color:backgroundColor,child: const Center(child:  CircularProgressIndicator(color: tabColor,)))),
    );
  }
}

