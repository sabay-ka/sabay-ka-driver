import 'package:flutter/material.dart';
import 'package:sabay_ka/common/theme.dart';
import 'package:sabay_ka/feature/onboarding/splash_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:sabay_ka/services/pocketbase_service.dart';
import 'package:gem_kit/core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final locator = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  // Pocketbase SDK initialization (For Auth, DB)
  locator
      .registerSingletonAsync<PocketbaseService>(PocketbaseServiceImpl.create);
  // Magic Lane SDK initialization (For Map, Navigation)
  if (dotenv.env['MAGICLANE_API_KEY'] == null) {
    throw Exception('MAGICLANE_API_KEY is not set in .env');
  }
  await GemKit.initialize(appAuthorization: dotenv.env['MAGICLANE_API_KEY']);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: CustomTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashWidget());
  }
}
