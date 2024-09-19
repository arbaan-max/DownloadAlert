import 'dart:developer';
import 'package:download_tow/core/exports.dart';

/// [startApplication] is the entry point of the application.
/// It creates the [MaterialApp] and starts the [runApp] function.
/// It also adds the [AppBlocObserver] to debug.
/// It is used to debug the application.
Future<void> startApplication(FutureOr<Widget> Function() builder) async {
  try {
    /// insureInitialization is used to insure that the initialization of the application is done.
    WidgetsFlutterBinding.ensureInitialized();
  } on Exception catch (_) {
    throw Exception('firebase initialization error occured!');
  }

  await requestMediaPhotosPermissions();
  await requestNotificationPermissions();

  final app = await builder();
  runApp(app);
}

Future<void> requestMediaPhotosPermissions() async {
  bool permissionStatus;
  final deviceInfo = await DeviceInfoPlugin().androidInfo;

  if (deviceInfo.version.sdkInt > 32) {
    permissionStatus = await Permission.photos.request().isGranted;
    // Directory? dir;
    // dir = Directory('/storage/emulated/0/Pictures/tow/'); // for android
    // if (!await dir.exists()) {
    //   await dir.create(recursive: true);
    //   dir = (await getExternalStorageDirectory())!;
    // }
    log(permissionStatus.toString());
  } else {
    permissionStatus = await Permission.manageExternalStorage.request().isGranted;
    log(permissionStatus.toString());
  }
}

Future<void> requestNotificationPermissions() async {
  if (await Permission.notification.isGranted) {
    log("Notification permission granted");
  } else {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      log("Notification permission granted after request");
    } else {
      log("Notification permission denied after request");
    }
  }
}
