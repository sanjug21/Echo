import 'dart:io';

import 'package:echo/auth/screens/landing_screen.dart';
import 'package:echo/routes.dart';
import 'package:echo/web/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'auth/auth_controller.dart';
import 'common/Widget/loader.dart';
import 'common/color.dart';
import 'home/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAAyGvkbL3orJSxE0-9W_YuSqBA1FJZNJQ",
        authDomain: "echo-2d7d7.firebaseapp.com",
        projectId: "echo-2d7d7",
        storageBucket: "echo-2d7d7.appspot.com",
        messagingSenderId: "918994882869",
        appId: "1:918994882869:web:9941d68636504048b9bc7c",
        measurementId: "G-6CHDR9QZHX",
      ),
    );
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA4wTbgLNHg0My2WT9-yhpb83UnsUM8_Ro",
        appId: "11:918994882869:android:51ba81577e038906b9bc7c",
        messagingSenderId: "918994882869",
        projectId: "echo-2d7d7",
        storageBucket: "echo-2d7d7.appspot.com",
      ),
    );
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var size=MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Echo',
      // theme: ThemeData.dark().copyWith(
      //     textSelectionTheme:
      //         TextSelectionThemeData(selectionHandleColor: tabColor),
      //     colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) => generateRoute(settings),
      home:size.width>500?LoginWeb(): ref.watch(userDataProvider).when(
          data: (user) {
            if (user == null) {
              return const LandingScreen();
            }
            return const Welcome();
          },
          error: (error, trace) {
            return const Scaffold(
              body: Center(
                child: Text(
                    "Some error occurred try again later or check for internet connection"),
              ),
            );
          },
          loading: () => const Loader()),
    );
  }
}
