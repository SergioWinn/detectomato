import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'detection_screen.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex; // 0: home, 1: camera, 2: profile

  const CustomNavbar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double navbarTop = 787 / 852 * screenHeight;
    double navbarHeight = 65 / 852 * screenHeight;
    double iconSize = 36.0;
    double circleSize = 60 / 393 * screenWidth;
    double stroke = 6.0;
    double iconTop = navbarTop + (navbarHeight - iconSize) / 2;

    return Stack(
      children: [
        // Rectangle kecil navbar
        Positioned(
          left: 0,
          top: 782 / 852 * screenHeight,
          child: Container(
            width: screenWidth,
            height: 5 / 852 * screenHeight,
            color: const Color(0xFF006D00),
          ),
        ),
        // Box navbar utama
        Positioned(
          left: 0,
          top: navbarTop,
          child: Container(
            width: screenWidth,
            height: navbarHeight,
            color: const Color(0xFF6DC61A),
          ),
        ),
        // Lingkaran kamera navbar
        Positioned(
          left: (screenWidth - (circleSize + 2 * stroke)) / 2,
          top: navbarTop - (circleSize / 2) - stroke,
          child: Container(
            width: circleSize + 2 * stroke,
            height: circleSize + 2 * stroke,
            decoration: const BoxDecoration(
              color: Color(0xFF6DC61A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: const BoxDecoration(
                  color: Color(0xFF006D00),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        // Icon kamera (center horizontal, hijau muda)
        Positioned(
          left: (screenWidth - iconSize) / 2,
          top: navbarTop - iconSize / 2,
          child: GestureDetector(
            onTap: () {
              if (selectedIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DetectionScreen()),
                );
              }
            },
            child: Icon(
              Icons.camera_alt_rounded,
              size: iconSize,
              color: const Color(0xFF6DC61A),
            ),
          ),
        ),
        // Icon Home (TIDAK ADA LINGKARAN, warna tetap hijau tua)
        Positioned(
          left: (screenWidth / 4) - (iconSize / 2),
          top: iconTop,
          child: GestureDetector(
            onTap: () {
              if (selectedIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
                      return FadeTransition(opacity: curved, child: child);
                    },
                  ),
                );
              }
            },
            child: Icon(
              Icons.home_rounded,
              size: iconSize,
              color: const Color(0xFF006D00),
            ),
          ),
        ),
        // Icon Person (TIDAK ADA LINGKARAN, warna tetap hijau tua)
        Positioned(
          left: (screenWidth * 3 / 4) - (iconSize / 2),
          top: iconTop,
          child: GestureDetector(
            onTap: () {
              if (selectedIndex != 2) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => const ProfileScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
                      return FadeTransition(opacity: curved, child: child);
                    },
                  ),
                );
              }
            },
            child: Icon(
              Icons.person_rounded,
              size: iconSize,
              color: const Color(0xFF006D00),
            ),
          ),
        ),
      ],
    );
  }
}