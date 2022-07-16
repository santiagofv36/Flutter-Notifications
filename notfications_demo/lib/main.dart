import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notfications_demo/home_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Coming from background");
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyANPiBSp88mirUgLxn0yYEexScm1uCgJcQ",
            authDomain: "webapp-a31ae.firebaseapp.com",
            projectId: "webapp-a31ae",
            storageBucket: "webapp-a31ae.appspot.com",
            messagingSenderId: "529367101886",
            appId: "1:529367101886:web:8b6eb7164a47ff660bc9ef",
            measurementId: "G-GLXQZLSNLG"));
  }
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.getToken().then((token) {
    print("Token: $token");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
