import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../notification/firebaseMessaging/firebase_messaging_service.dart';
import '../viewModel/notification_view_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final notificationViewModel = Provider.of<NotificationViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: notificationViewModel.notificationStatus == null
                  ? false
                  : true,
              onChanged: (value) {
                notificationViewModel.changeNotificationStatus(value);
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {});
              },
              child: SelectableText(
                FirebaseMessagingService.instance.token ?? 'token get',
              ),
            ),
            TextButton(
              onPressed: () async {
                var msg = {
                  "to":
                  'dvxBRdRLTqa_84S4VjFfu3:APA91bFLzF1vTQBAd2fHghroOA1xUq-Ew3yvGmvS2xt34IWEDhjLARud7WAY9EwtKTneN1RxyGRo2lNFFg7ZcKsKZqB342l7UsnGx9tkjnqEo7FnYc1X5c5VV8BO8XhW4eoifKZa4tpW',
                  // eğer notificationı göndermezsek bildirim otomatik olarak oluşmuyo
                  "notification": {"title": "aa", "body": "body"},
                  // "data": {"title": "Testt2", "body": "Heyy2"}
                };
                await http.post(
                  Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization':
                    'key=AAAApgEnkgM:APA91bFJTPvNkAXbbvcwqlF4hpzbmLL9O8aaINO-59Tpf0yBE8IHEioLAJsT0HJAkMta1xeQ7KM-pmUY5BEuFiJJ0e8xf-RUQRjQfisFedwHeBLMX1_Ab5SBiE99TCMbZPtQLApbPKte'
                  },
                  body: jsonEncode(msg),
                );
              },
              child: const Text('Tap'),
            ),
          ],
        ),
      ),
    );
  }
}
