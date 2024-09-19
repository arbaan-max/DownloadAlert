part of 'download_bloc.dart';

sealed class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadProduct extends DownloadEvent {
  final Function(double) onProgress;
  final String url;
  final String imageID;

  const DownloadProduct({
    required this.onProgress,
    required this.url,
    required this.imageID,
  });

  @override
  List<Object> get props => [onProgress, url, imageID];
}
