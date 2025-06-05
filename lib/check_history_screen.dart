import 'package:flutter/material.dart';

class CheckHistoryScreen extends StatelessWidget {
  const CheckHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dummy data
    final history = [
      {
        "month": "MAY",
        "items": [
          {"img": "assets/images/00bce074-967b-4d50-967a-31fdaa35e688___RS_HL 0223_flipTB.jpeg", "label": "Healthy"},
          {"img": "assets/images/03b7a13c-f5c0-44c4-beed-443841670e9a___RS_Erly.B 8225.jpeg", "label": "Early Blight"},
          {"img": "assets/images/014b5e19-7917-4d76-b632-b5dd31d999ec___RS_HL 9640.jpeg", "label": "Healthy"},
        ]
      },
      {
        "month": "APRIL",
        "items": [
          {"img": "assets/images/014b58ae-091b-408a-ab4a-5a780cd1c3f3___GCREC_Bact.Sp 2971.jpeg", "label": "Bacterial Spot"},
          {"img": "assets/images/005a2c1f-4e15-49e4-9e5c-61dc3ecf9708___RS_Late.B 5096_flipLR.jpeg", "label": "Late Blight"},
        ]
      },
    ];

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
          // Judul History
          Positioned(
            left: 0,
            right: 0,
            top: 150 / 852 * screenHeight,
            child: const Center(
              child: Text(
                "History",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Label "MAY" di posisi 25, 250
          Positioned(
            left: 25 / 393 * screenWidth,
            top: 250 / 852 * screenHeight,
            child: Text(
              "MAY",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          // Box item untuk setiap history di bulan MAY
          ...List.generate((history[0]["items"] as List).length, (index) {
            final item = (history[0]["items"] as List)[index];
            final String img = item["img"] as String;
            final String label = item["label"] as String;
            return Positioned(
              left: 25 / 393 * screenWidth,
              top: (280 + index * (100 + 16)) / 852 * screenHeight,
              child: Stack(
                children: [
                  // Box hijau
                  Container(
                    width: 343 / 393 * screenWidth,
                    height: 100 / 852 * screenHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6DC61A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // Gambar (di atas box, mepet kiri)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        img,
                        height: 100 / 852 * screenHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Teks (x=125 terhadap box)
                  Positioned(
                    left: 125 / 393 * screenWidth,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: (343 - 125) / 393 * screenWidth,
                      height: 100 / 852 * screenHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          // Label "APRIL" dan history-nya (posisi di bawah list MAY)
          Positioned(
            left: 25 / 393 * screenWidth,
            top: (250 + 32 + (history[0]["items"] as List).length * (100 + 16)) / 852 * screenHeight,
            child: Text(
              "APRIL",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          // Box item untuk setiap history di bulan APRIL
          ...List.generate((history[1]["items"] as List).length, (index) {
            final item = (history[1]["items"] as List)[index];
            final String img = item["img"] as String;
            final String label = item["label"] as String;
            // Hitung posisi y APRIL: mulai setelah semua item MAY + jarak 32
            final double aprilStartY = (280 + (history[0]["items"] as List).length * (100 + 16) + 32);
            return Positioned(
              left: 25 / 393 * screenWidth,
              top: (aprilStartY + index * (100 + 16)) / 852 * screenHeight,
              child: Stack(
                children: [
                  // Box hijau
                  Container(
                    width: 343 / 393 * screenWidth,
                    height: 100 / 852 * screenHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6DC61A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // Gambar (di atas box, mepet kiri)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        img,
                        height: 100 / 852 * screenHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Teks (x=125 terhadap box)
                  Positioned(
                    left: 125 / 393 * screenWidth,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: (343 - 125) / 393 * screenWidth,
                      height: 100 / 852 * screenHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}