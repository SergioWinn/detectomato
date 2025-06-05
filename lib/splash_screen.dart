import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import 'profile_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final email = profileProvider.email;

      if (email.isNotEmpty && mounted) {
        // Sudah login, langsung ke HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (mounted) {
        // Belum login, ke Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  int _screenIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeOut,
        child: _buildSplashContent(_screenIndex, key: ValueKey(_screenIndex)),
      ),
    );
  }

  Widget _buildSplashContent(int index, {required Key key}) {
    switch (index) {
      case 1:
        return Container(key: key, color: const Color(0xFF006D00));
      case 2:
        return Container(
          key: key,
          color: const Color(0xFF6DC61A),
          child: Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                child: Opacity(
                  opacity: 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/main_logo.png',
                        width: 393 / 393 * MediaQuery.of(context).size.width,
                        height: 393 / 852 * MediaQuery.of(context).size.height,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      case 3:
        return Container(
          key: key,
          color: const Color(0xFFC9F2A8),
          child: Center(
            child: Image.asset(
              'assets/images/main_logo.png',
              width: 393 / 393 * MediaQuery.of(context).size.width,
              height: 393 / 852 * MediaQuery.of(context).size.height,
            ),
          ),
        );
      default:
        return Container(key: key);
    }
  }
}
