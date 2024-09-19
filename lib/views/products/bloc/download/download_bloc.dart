import 'dart:io';

import 'package:download_tow/core/exports.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final LocalNotificationService notificationService;
  final Dio dio;
  DownloadBloc({
    required this.notificationService,
    required this.dio,
  }) : super(DownloadInitial()) {
    on<DownloadProduct>(_onDownloadProduct);
  }

  Future<void> _onDownloadProduct(DownloadProduct event, Emitter<DownloadState> emit) async {
    emit(DownlaodLoading());

    try {
      // // Check if permissions were granted during app initialization
      // final permissionStatus = await Permission.manageExternalStorage.isGranted;

      // if (!permissionStatus) {
      //   emit(const ProductError("Storage permission denied"));
      //   return;
      // }
      final imgID = int.tryParse(event.imageID) ?? 0;
      Directory? dir;
      dir = Directory('/storage/emulated/0/Pictures/tow/'); // for android
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        dir = (await getExternalStorageDirectory())!;
      }
      final imageDateTime = DateTime.now().millisecondsSinceEpoch;
      String savePath = '${dir.path}/_img_${imageDateTime}_${event.imageID}.jpg';
      notificationService.showDownloadProgressNotification(0, imgID);
      await Dio().download(
        event.url,
        savePath,
        onReceiveProgress: (rec, total) {
          if (total != -1) {
            final progress = rec / total * 100;
            emit(DownloadingState(progress));
            notificationService.showDownloadProgressNotification(progress, imgID);
          }

          // double progress = (rec / total) * 100;
          // emit(DownloadingState(progress));
          // event.onProgress(progress);
        },
      );

      await _addImageToGallery(savePath);
      emit(DownloadCompleted());
      Future.delayed(const Duration(seconds: 2), () {
        notificationService.showDownloadCompleteNotification(imgID);
      });
    } catch (e) {
      emit(DownloadError(e.toString()));
    }
  }

  /// Add the image to the gallery
  Future<void> _addImageToGallery(String imagePath) async {
    try {
      // Use MediaScannerConnection to scan the image and add it to the gallery
      const channel = MethodChannel('media_scanner');
      await channel.invokeMethod('scanFile', {'path': imagePath});
    } catch (e) {
      debugPrint('\x1B[31m Error adding to gallery: $e \x1B[0m');
    }
  }
}
