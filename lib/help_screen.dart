import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
          // Konten utama
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Support & Feedback",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: responsiveFont(28),
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: 320 / 393 * screenWidth,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6DC61A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ada pertanyaan, saran, atau kendala?",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: responsiveFont(18),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Hubungi kami di support.detectomato@gmail.com\natau klik tombol di bawah untuk mengirim feedback.",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: responsiveFont(16),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200 / 393 * screenWidth,
                  height: 48 / 852 * screenHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006D00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'support.detectomato@gmail.com',
                        query: 'subject=Detectomato Feedback&body=Halo Detectomato Team,',
                      );
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open email app')),
                        );
                      }
                    },
                    child: Text(
                      "Send Feedback",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: responsiveFont(18),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}