import 'package:flutter/material.dart';
import 'check_history_screen.dart'; // Tambahkan import ini di atas
import 'clear_history_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double circleSize = 100 / 393 * screenWidth;
    double iconSize = 50.0;

    double responsiveFont(double figmaFont) => figmaFont * screenWidth / 393;

    return Scaffold(
      backgroundColor: const Color(0xFFDFFDC9),
      body: Stack(
        children: [
          // Tombol back
          Positioned(
            left: 10 / 393 * screenWidth,
            top: 60 / 852 * screenHeight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40 / 393 * screenWidth,
                height: 40 / 393 * screenWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFF6DC61A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          // Menu grid
          Positioned(
            top: 225 / 852 * screenHeight,
            left: 50 / 393 * screenWidth,
            right: 50 / 393 * screenWidth,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SettingsMenu(
                      icon: Icons.history,
                      label: "Check\nHistory",
                      circleSize: circleSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CheckHistoryScreen()),
                        );
                      },
                    ),
                    _SettingsMenu(
                      icon: Icons.delete_forever,
                      label: "Clear\nHistory",
                      circleSize: circleSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ClearHistoryScreen()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40 / 852 * screenHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SettingsMenu(
                      icon: Icons.help,
                      label: "Help",
                      circleSize: circleSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final double circleSize;
  final double iconSize;
  final VoidCallback onTap;

  const _SettingsMenu({
    required this.icon,
    required this.label,
    required this.circleSize,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double responsiveFont(double figmaFont) => figmaFont * screenWidth / 393;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
              color: Color(0xFF6DC61A),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: iconSize, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: responsiveFont(16),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}