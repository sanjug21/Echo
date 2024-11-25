import 'package:echo/common/color.dart';
import 'package:echo/home/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';

class Welcome extends ConsumerStatefulWidget {
  static const routeName = '/welcome';
  const Welcome({super.key});

  @override
  ConsumerState<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<Welcome>with WidgetsBindingObserver,TickerProviderStateMixin {
  int page=0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController=PageController();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:

      case AppLifecycleState.hidden:

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider).setUserState(false);
        break;


    }
  }
  void onPageChanged(int currPage){
setState(() {
  page=currPage;
});
  }
  void pageTapped(int currPage){
pageController.jumpToPage(currPage);

  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(

        length: 3,
        child: Scaffold(

          body: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: welcomeItems,
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 50,
            currentIndex: page,
            onTap: pageTapped,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            iconSize: 25,
            selectedItemColor: tabColor,
            unselectedItemColor: Colors.white,
            showSelectedLabels: true,
            backgroundColor: Colors.black,
            items:  const[
              BottomNavigationBarItem(
                icon: Icon(Icons.home,),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud,),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person,),
                label: "Profile",
              ),
            ],
          ),
        ));
  }
}
