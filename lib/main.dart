import 'package:app/pages/splash.dart';
import 'package:app/repositories/alert_repository.dart';
import 'package:app/repositories/analysis_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiKey = const String.fromEnvironment('API_KEY_GEMINI');

  Gemini.init(apiKey: apiKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AlertRepository()),
        ChangeNotifierProvider(create: (context) => AnalysisRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const SplashPage(),
    );
  }
}
