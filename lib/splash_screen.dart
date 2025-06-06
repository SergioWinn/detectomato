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
  int _screenIndex = 1;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  void _startSplashSequence() {
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _screenIndex = 2);
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() => _screenIndex = 3);
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          _checkAuthStatus();
        });
      });
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final email = profileProvider.email;

      if (email.isNotEmpty && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (mounted) {
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
