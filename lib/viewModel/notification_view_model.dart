import 'package:flutter/material.dart';

import '../consts/local_constants.dart';
import '../local/local_service.dart';
import '../notification/awesome/awesome_schedule_notification.dart';
import '../notification/firebaseMessaging/firebase_messaging_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final localService = LocalService.instance;
  final awesomeNotification = AwesomeScheduleNotification.instance;
  final firebaseMessagingService = FirebaseMessagingService.instance;

  bool? get notificationStatus =>
      localService.read(LocalConstants.notificationStatus);

  set notificationStatus(bool? notificationStatus) =>
      this.notificationStatus = notificationStatus;

  Future<void> init() async => await firebaseMessagingService.init();

  Future<void> changeNotificationStatus(value) async {
    if (value == false) {
      await awesomeNotification.cancel();
    } else {
      await awesomeNotification.startScheduleNotification(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute + 1,
      );
    }
    notifyListeners();
  }
}
