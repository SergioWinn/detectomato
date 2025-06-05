import 'package:flutter/material.dart';
import 'onboarding_page1.dart';
import 'onboarding_page2.dart';
import 'onboarding_page3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _goToPage2() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300), // Durasi animasi
        pageBuilder: (context, animation, secondaryAnimation) =>
            OnboardingPage2(onNext: _goToPage3),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeOut; // Kurva animasi easeOut
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _goToPage3() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300), // Durasi animasi
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingPage3(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeOut; // Kurva animasi easeOut
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPage1(onNext: _goToPage2), // Halaman pertama
    );
  }
}