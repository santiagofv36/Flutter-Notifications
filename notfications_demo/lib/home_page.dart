import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notfications_demo/services/local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _token = 'token';

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
      if (kIsWeb) {
        showDialog(
            context: context,
            builder: ((BuildContext context) {
              return DynamicDialog(
                  title: message.notification!.title,
                  body: message.notification!.body);
            }));
      } else {
        localNotificationService.showNotificationOnForeground(message);
      }
      setState(() {
        msg =
            "${message.notification!.title} ${message.notification!.body} I am coming from foreground";
      });
    });
    //Background State
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      send();
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
          child: (kIsWeb)
              ? ElevatedButton(
                  onPressed: delayedMessage,
                  child: Text(msg),
                )
              : Text(msg),
        ),
      ),
    );
  }

  send() async {
    _token = await FirebaseMessaging.instance.getToken();
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAe0C88b4:APA91bFkR8LYkO0vmIuNuZoykgt78X3TLnwMPZenVVjGbA0X64fTyBYKG3poTu36n66mmAmya_aTZcCQ2KtW5JPJ7ccJuWkFMOAz6elI-fZnpv1P5yD50vHR7Rf_jHeIQpppc_2W6NSK'
            },
            body: json.encode({
              'to': _token,
              'message': {
                'token': _token,
              },
              "notification": {
                "title": "Push Notification",
                "body": "Firebase  push notification"
              }
            }),
          )
          .then((value) => print(value.body));
      print('FCM request for web sent!');
    } catch (e) {
      print(e);
    }
  }

  delayedMessage() {
    Future.delayed(Duration(seconds: 5), () {
      print("Sent after 5 seconds");
      send();
    });
  }
}

class DynamicDialog extends StatefulWidget {
  final title;
  final body;
  DynamicDialog({this.title, this.body});
  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: <Widget>[
        OutlinedButton.icon(
            label: const Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close))
      ],
      content: Text(widget.body),
    );
  }
}
