import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    _notificationsPlugin.initialize(initializationSettings);
  }

  // Show progress notification while downloading
  void showDownloadProgressNotification(double progress, int notificationID) {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel',
      'Download Progress',
      channelDescription: 'Notification for download progress',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress.toInt(),
      indeterminate: false,
      autoCancel: false,
      ongoing: true,
      playSound: false,
      enableVibration: false,
      icon: '@drawable/download',
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    _notificationsPlugin.show(
      notificationID,
      'Downloading Image',
      'Download in progress...',
      platformChannelSpecifics,
    );
    // if (progress == 100) {
    // _notificationsPlugin.cancel(notificationID);
    // }
  }

  // Show notification for download complete and auto-cancel it
  void showDownloadCompleteNotification(int notificationID) async {
    // Now show the completion notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel',
      'Download Complete',
      channelDescription: 'Notification for download completion',
      importance: Importance.low,
      priority: Priority.low,
      autoCancel: true,
      playSound: false,
      enableVibration: false,
      icon: '@drawable/tick',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    _notificationsPlugin.show(
      notificationID,
      'Download Complete',
      'Image downloaded successfully!',
      platformChannelSpecifics,
    );
  }
}
