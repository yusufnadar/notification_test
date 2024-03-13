import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'local/local_service.dart';
import 'notification/awesome/awesome_notification_service.dart';
import 'page/notification_page.dart';
import 'viewModel/notification_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await AwesomeNotificationService.instance.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationViewModel>(
          create: (context) => NotificationViewModel()..init(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: LocalService.instance.navigatorKey,
      home: const NotificationPage(),
    );
  }
}
