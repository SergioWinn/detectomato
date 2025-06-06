import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double responsiveFont(double figmaFont) => figmaFont * screenWidth / 393;

    return Container(
      color: const Color(0xFFDFFDC9),
      child: Stack(
        children: [
          Positioned(
            left: 35 / 393 * MediaQuery.of(context).size.width,
            right: 35 / 393 * MediaQuery.of(context).size.width,
            top: 150 / 852 * MediaQuery.of(context).size.height,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome to\n",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: responsiveFont(40),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 50 / 40, // Line height dihitung relatif terhadap font size
                    ),
                  ),
                  TextSpan(
                    text: "Detectomato!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: responsiveFont(40),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      height: 50 / 40, // Line height dihitung relatif terhadap font size
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 35 / 393 * MediaQuery.of(context).size.width,
            right: 35 / 393 * MediaQuery.of(context).size.width,
            top: 275 / 852 * MediaQuery.of(context).size.height,
            child: Text(
              'An intelligent application to detect tomato plant diseases quickly and accurately.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: responsiveFont(16),
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 20 / 16,
              ),
            ),
          ),
          Positioned(
            left: 47 / 393 * MediaQuery.of(context).size.width,
            top: 426 / 852 * MediaQuery.of(context).size.height,
            right: 47 / 393 * MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/tomato_logo.png',
              width: 300 / 393 * MediaQuery.of(context).size.width,
              height: 300 / 852 * MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            left: 255 / 393 * MediaQuery.of(context).size.width,
            top: 724 / 852 * MediaQuery.of(context).size.height,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6DC61A),
                minimumSize: Size(
                  102.55 / 393 * MediaQuery.of(context).size.width, // Lebar tombol responsif
                  35 / 852 * MediaQuery.of(context).size.height,   // Tinggi tombol responsif
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: responsiveFont(12.6),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}