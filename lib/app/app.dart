import 'package:download_tow/core/exports.dart';

/// A stateless widget that represents the main application.
/// This class is the entry point of the application and is responsible for
/// setting up the initial state and configuration of the app.
class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(
            dio: Dio(),
          )..add(FetchProduct()),
        ),
        BlocProvider(
          create: (context) => DownloadBloc(
            notificationService: LocalNotificationService(),
            dio: Dio(),
          ),
        ),
      ],
      child: const MaterialApp(
        home: ProductPage(),
      ),
    );
  }
}
