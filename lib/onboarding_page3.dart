import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFFDC9),
      body: Stack(
        children: [
          Positioned(
            left: 10 / 393 * MediaQuery.of(context).size.width,
            top: 60 / 852 * MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Atau aksi lain sesuai flow onboarding Anda
              },
              child: Container(
                width: 35 / 393 * MediaQuery.of(context).size.width,
                height: 35 / 393 * MediaQuery.of(context).size.width,
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
          Positioned(
            left: 35 / 393 * MediaQuery.of(context).size.width,
            top: 150 / 852 * MediaQuery.of(context).size.height,
            right: 35 / 393 * MediaQuery.of(context).size.width,
            child: const Text(
              'Ready to Protect Your Plants?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 50 / 40, // Line height dihitung relatif terhadap font size
              ),
            ),
          ),
          Positioned(
            left: 35 / 393 * MediaQuery.of(context).size.width,
            top: 325 / 852 * MediaQuery.of(context).size.height,
            right: 35 / 393 * MediaQuery.of(context).size.width,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Start using ",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "Detectomato",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: " and keep your tomato plants healthy!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 124 / 393 * MediaQuery.of(context).size.width,
            top: 641 / 852 * MediaQuery.of(context).size.height,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6DC61A),
                minimumSize: Size(
                  146.5 / 393 * MediaQuery.of(context).size.width, // Lebar tombol responsif
                  50 / 852 * MediaQuery.of(context).size.height,   // Tinggi tombol responsif
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.5), // Corner radius diubah menjadi 15
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}