import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage2({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFFDC9),
      body: Stack(
        children: [
          Positioned(
            left: 35 / 393 * MediaQuery.of(context).size.width,
            right: 35 / 393 * MediaQuery.of(context).size.width,
            top: 150 / 852 * MediaQuery.of(context).size.height,
            child: const Text(
              'Instant Disease Detection',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 50 / 40, // Line height dihitung relatif terhadap font size
              ),
              softWrap: true, // Memastikan teks ter-wrap ke bawah
              overflow: TextOverflow.visible, // Menghindari overflow
            ),
          ),
          Positioned(
            left: 35 / 393 * MediaQuery.of(context).size.width,
            top: 275 / 852 * MediaQuery.of(context).size.height,
            right: 35 / 393 * MediaQuery.of(context).size.width,
            child: const Text(
              'Simply upload a photo of a tomato leaf, and get a diagnosis in seconds.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            left: 49 / 393 * MediaQuery.of(context).size.width,
            top: 340 / 852 * MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/tomato_mockup.png',
              width: 191 / 393 * MediaQuery.of(context).size.width,
              height: 414.08 / 852 * MediaQuery.of(context).size.height,
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
                children: const [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.6,
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
        ],
      ),
    );
  }
}