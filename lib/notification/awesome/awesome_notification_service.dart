import 'dart:convert';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../../consts/notification_constants.dart';
import '../../local/local_service.dart';
import '../../page/test_page.dart';
import 'awesome_schedule_notification.dart';

class AwesomeNotificationService {
  // singleton olarak aktifleştiriyoruz
  AwesomeNotificationService._init();

  static final AwesomeNotificationService _instance =
      AwesomeNotificationService._init();

  static AwesomeNotificationService get instance => _instance;

  // awesome notification paketini tanımlıyoruz
  final awesomeNotification = AwesomeNotifications();

  // schedule notification aktifleştirilecekse sınıfına ulaşıyoruz
  final awesomeScheduleNotification = AwesomeScheduleNotification.instance;

  Future<void> init() async {
    // initialize notification

    await initializeNotificationChannel();

    // eğer bildirim gönderme izni daha önce alındıysa tekrardan alınmıyor
    var permission = await checkPermissionList();
    if (permission.isEmpty) {
      // bildirim izni alınmadıysa izin isteniyor
      await requestPermissionToSendNotifications();
    }
    // bildirime tıklandığında, oluşturulduğunda, görüntülendiğinde ya da
    // kaydırıldığında bu kısımlar tetikleniyor
    awesomeNotification.setListeners(
      onActionReceivedMethod: onActionReceiveMethod,
      onNotificationCreatedMethod:
          (ReceivedNotification receivedNotification) async {},
      onNotificationDisplayedMethod:
          (ReceivedNotification receivedNotification) async {},
      onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {},
    );
    // uygulama açılışında otomatik olara saat ve dakika gönderilip
    // her gün düzenli olarak bildirim oluşturulması sağlanıyor
    await awesomeScheduleNotification.checkDateAndActivateNotification(
      hour: 19,
      minute: 24,
    );
  }

  Future<bool> requestPermissionToSendNotifications() {
    // bildirim izni alırken gelen bildirimin yukarıdan kayarak gelmesi
    // için de bildirim isteği atıyoruz
    // ses, uyarı, ışık yanıyorsa ışık, bildirim sayısı artıcaksa, titreme
    // olacaksa bu izinleri de alıyoruz
    return awesomeNotification.requestPermissionToSendNotifications(
      channelKey: NotificationConsts.channelKey,
      permissions: [
        NotificationPermission.Sound,
        NotificationPermission.Alert,
        NotificationPermission.Light,
        NotificationPermission.Badge,
        NotificationPermission.Vibration,
      ],
    );
  }

  Future<List<NotificationPermission>> checkPermissionList() {
    // bildirim izni alınmış mı diye kontrol ediliyor
    return awesomeNotification.checkPermissionList(
      channelKey: NotificationConsts.channelKey,
      permissions: [
        NotificationPermission.Alert,
        NotificationPermission.Sound,
        NotificationPermission.Light,
        NotificationPermission.Badge,
        NotificationPermission.Vibration,
      ],
    );
  }

  Future<void> initializeNotificationChannel() async {
    // özellikleri girilerek initialize ediliyor
    await awesomeNotification.initialize(
      null,
      [
        NotificationChannel(
          // TODO: Bu kısmı araştır
          channelGroupKey: NotificationConsts.channelKey,
          channelKey: NotificationConsts.channelKey,
          channelName: NotificationConsts.channelName,
          channelShowBadge: true,
          criticalAlerts: true,
          importance: NotificationImportance.High,
          channelDescription: NotificationConsts.channelDescription,
        )
      ],
      debug: false,
    );
  }
}

Future<void> onActionReceiveMethod(ReceivedAction receivedAction) async {
  if (Platform.isIOS == true) {
    // push notification - kapalı - getInitialMessageda tetikleniyor
    // cloud messaging - kapalı - getInitialMessageda tetikleniyor
    // push notification - açık - onMessageOpenedApple.listenda tetikleniyor
    // push notification - arka plan - onMessageOpenedApple.listenda tetikleniyor
    // cloud messaging - açık - onMessageOpenedApple.listenda tetikleniyor
    // cloud messaging - arka plan - onMessageOpenedApple.listenda tetikleniyor

    // firebase bildirimiyle local notification bildirimi
    // çakışmasın diye kontrol ediyoruz
    if (receivedAction.summary == 'local') {
      // do something
    }
  } else if (Platform.isAndroid == true) {
    // push notification - açık
    // cloud messaging - açık
    // push notification - kapalı - otomatik değilse
    // cloud messaging - arka plan - otomatik değilse
    // cloud messaging - kapalı - otomatik değilse

    // example payload (json.decode(receivedAction.payload!['data']!))['type']
    if (receivedAction.summary == 'local') {
      // do something
    }
  }
}
