import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notfications_demo/services/local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _token;

  String msg = "Waiting for message";

  @override
  void initState() {
    localNotificationService.initialize();

    super.initState();
    //Terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        setState(() {
          msg =
              "${message.notification!.title} ${message.notification!.body} I am coming from Terminated state";
        });
      }
    });
    //Foreground State
    FirebaseMessaging.onMessage.listen((message) {
      localNotificationService.showNotificationOnForeground(message);
      setState(() {
        msg =
            "${message.notification!.title} ${message.notification!.body} I am coming from foreground";
      });
    });
    //Background State
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      setState(() {
        msg =
            "${message.notification!.title} ${message.notification!.body} I am coming from background";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase push notification'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(10),
          elevation: 10,
          child: ListTile(
            title: Center(
              child: Text(msg),
            ),
          ),
        ),
      ),
    );
  }
}
