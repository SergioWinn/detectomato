import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'detection_screen.dart';
import 'custom_navbar.dart';
import 'edit_profile_screen.dart';
import 'profile_provider.dart';
import 'package:provider/provider.dart';
import 'sign_in_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

    final username = context.watch<ProfileProvider>().username;

    return Scaffold(
      backgroundColor: const Color(0xFFDFFDC9),
      body: Stack(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetectionScreen()),
                );
              },
              child: Icon(
                Icons.camera_alt_rounded,
                size: iconSize,
                color: const Color(0xFF6DC61A),
              ),
            ),
          ),
          // Icon Home
          Positioned(
            left: (screenWidth / 4) - (iconSize / 2),
            top: iconTop,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Icon(
                Icons.home_rounded,
                size: iconSize,
                color: const Color(0xFF006D00),
              ),
            ),
          ),
          // Icon Person (aktif)
          Positioned(
            left: (screenWidth * 3 / 4) - (iconSize / 2),
            top: iconTop,
            child: Icon(
              Icons.person_rounded,
              size: iconSize,
              color: const Color(0xFF6DC61A),
            ),
          ),
          // Box hijau profil (responsive)
          Positioned(
            left: 25 / 393 * screenWidth,
            top: 140 / 852 * screenHeight,
            child: Container(
              width: 343 / 393 * screenWidth,
              height: 121.6 / 852 * screenHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF6DC61A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // Gambar tomat
                  Positioned(
                    left: 10 / 393 * screenWidth,
                    top: (121.6 / 852 * screenHeight - 100 / 852 * screenHeight) / 2,
                    child: Image.asset(
                      'assets/images/tomato_profile.png',
                      width: 100 / 393 * screenWidth,
                      height: 100 / 852 * screenHeight,
                    ),
                  ),
                  // Username (otomatis dari provider)
                  Positioned(
                    left: 115 / 393 * screenWidth,
                    top: ((0.55 * 121.6) / 2 - 16) / 852 * screenHeight,
                    width: 343 / 393 * screenWidth - 115 / 393 * screenWidth,
                    child: SizedBox(
                      height: 0.55 * 121.6 / 852 * screenHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Biodata (otomatis dari provider)
                  Positioned(
                    left: 115 / 393 * screenWidth,
                    top: (0.55 * 121.6 / 852 * screenHeight),
                    width: 343 / 393 * screenWidth - 115 / 393 * screenWidth,
                    child: SizedBox(
                      height: 0.45 * 121.6 / 852 * screenHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.watch<ProfileProvider>().biodata,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tombol Edit Profile
          Positioned(
            left: 40 / 393 * screenWidth,
            top: 326 / 852 * screenHeight,
            child: _ProfileMenuBox(
              width: 313 / 393 * screenWidth,
              height: 100 / 852 * screenHeight,
              icon: Icons.edit,
              label: "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),
          ),
          // Tombol Settings
          Positioned(
            left: 40 / 393 * screenWidth,
            top: 460 / 852 * screenHeight,
            child: _ProfileMenuBox(
              width: 313 / 393 * screenWidth,
              height: 100 / 852 * screenHeight,
              icon: Icons.settings,
              label: "Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ),
          // Tombol Log Out
          Positioned(
            left: 40 / 393 * screenWidth,
            top: 594 / 852 * screenHeight,
            child: _ProfileMenuBox(
              width: 313 / 393 * screenWidth,
              height: 100 / 852 * screenHeight,
              icon: Icons.logout,
              label: "Log Out",
              onTap: () {
                Provider.of<ProfileProvider>(context, listen: false).reset();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false,
                );
              },
            ),
          ),
          // Navbar di paling akhir agar selalu di bawah
          const CustomNavbar(selectedIndex: 2),
        ],
      ),
    );
  }
}

class _ProfileMenuBox extends StatelessWidget {
  final double width;
  final double height;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuBox({
    required this.width,
    required this.height,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
          color: const Color(0xFF6DC61A),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, color: Colors.black, size: 28),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}