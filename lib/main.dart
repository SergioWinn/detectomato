import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_provider.dart';
import 'splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://yhrctktmmgtyrcrsjozt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlocmN0a3RtbWd0eXJjcnNqb3p0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg4NzI1NzgsImV4cCI6MjA2NDQ0ODU3OH0.c4hHFEK5TJkWrpkbLjHm-w4Z1ejXGCeSAQ3Ah4AD7mE',
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const DetectomatoApp(),
    ),
  );
}

class DetectomatoApp extends StatelessWidget {
  const DetectomatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detectomato',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}