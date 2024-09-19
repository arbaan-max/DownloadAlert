import 'app/app.dart';
import 'app/start.dart';

/// [main] is the entry point of the application.
/// It is responsible for running the application.
/// It is the first function to be called when the application starts.
Future<void> main() async => await startApplication(() => const Application());
