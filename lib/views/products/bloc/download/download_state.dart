part of 'download_bloc.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

final class DownloadInitial extends DownloadState {}

class DownlaodLoading extends DownloadState {}

/// Download Events
class DownloadingState extends DownloadState {
  final double progress;
  const DownloadingState(this.progress);

  @override
  List<Object> get props => [progress];
}

class DownloadCompleted extends DownloadState {}

class DownloadError extends DownloadState {
  final String message;
  const DownloadError(this.message);

  @override
  List<Object> get props => [message];
}
