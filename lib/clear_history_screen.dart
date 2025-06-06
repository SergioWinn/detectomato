import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'profile_provider.dart';

Future<void> clearUserHistoryManual(BuildContext context) async {
  final userId = Provider.of<ProfileProvider>(context, listen: false).userId;
  if (userId.isEmpty) return;
  final supabase = Supabase.instance.client;
  await supabase
      .from('detection_history')
      .delete()
      .eq('user_id', userId);
}

class ClearHistoryScreen extends StatelessWidget {
  const ClearHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
          // Judul di posisi y = 279
          Positioned(
            left: 0,
            right: 0,
            top: 279 / 852 * screenHeight,
            child: Center(
              child: Text(
                "Are you sure to clear\nyour history?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveFont(30),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Tombol Yes di y = 400
          Positioned(
            left: (screenWidth - (343 / 393 * screenWidth)) / 2,
            top: 400 / 852 * screenHeight,
            child: SizedBox(
              width: 343 / 393 * screenWidth,
              height: 50 / 852 * screenHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006D00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  await clearUserHistoryManual(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: responsiveFont(20),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          // Tombol No di y = 475
          Positioned(
            left: (screenWidth - (343 / 393 * screenWidth)) / 2,
            top: 475 / 852 * screenHeight,
            child: SizedBox(
              width: 343 / 393 * screenWidth,
              height: 50 / 852 * screenHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6DC61A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Navigasi ke SettingsScreen dan hapus halaman ini
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    (route) => route.isFirst,
                  );
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: responsiveFont(20),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}