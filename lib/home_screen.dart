import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detection_screen.dart';
import 'profile_screen.dart'; // Tambahkan import ini
import 'custom_navbar.dart'; // Import CustomNavbar
import 'profile_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double responsiveFont(double figmaFont) => figmaFont * MediaQuery.of(context).size.width / 393;

    // Skala berdasarkan figma 393x852
    double boxWidth = 343 / 393 * screenWidth;
    double boxHeight = 152 / 852 * screenHeight;
    double boxLeft = (screenWidth - boxWidth) / 2;
    double boxTop = 85 / 852 * screenHeight;

    double tomatoSize = 100 / 393 * screenWidth;
    double tomatoLeft = boxLeft + 10 / 393 * screenWidth;
    double tomatoTop = boxTop + (boxHeight - tomatoSize) / 2;

    double textLeft = boxLeft + 115 / 393 * screenWidth;
    double textFontSize = responsiveFont(32);
    double textLineHeight = 40 / 32;

    // Hitung tinggi total 2 baris teks dengan line height
    double totalTextHeight = 2 * textFontSize * textLineHeight;
    double textTop = boxTop + (boxHeight - totalTextHeight) / 2;

    // Ukuran dan posisi News Box
    double newsBoxWidth = 156.38 / 393 * screenWidth;
    double newsBoxHeight = 139 / 852 * screenHeight;
    double newsBoxRadius = 20.85;

    // Gambar di dalam News Box
    double newsImageHeight = 86.18 / 139 * newsBoxHeight;

    // Posisi box
    double box1Left = 35 / 393 * screenWidth;
    double box1Top = 332 / 852 * screenHeight;
    double box2Left = 202 / 393 * screenWidth;
    double box2Top = box1Top;
    double box3Left = box1Left;
    double box3Top = 481 / 852 * screenHeight;
    double box4Left = box2Left;
    double box4Top = box3Top;

    // Posisi dan style judul news
    double newsTitleLeft = 6.95 / 156.38 * newsBoxWidth;
    double newsTitleTop = 93.82 / 139 * newsBoxHeight;
    double newsTitleFontSize = responsiveFont(11.12);
    double newsTitleLineHeight = 13.9 / 11.12;

    // Posisi dan style read more
    double readMoreLeft = newsTitleLeft;
    double readMoreTop = 111.2 / 139 * newsBoxHeight;

    double navbarTop = 787 / 852 * screenHeight;
    double navbarHeight = 65 / 852 * screenHeight;
    double iconSize = 36.0;
    double circleSize = 60 / 393 * screenWidth;
    double stroke = 6.0;
    double iconTop = navbarTop + (navbarHeight - iconSize) / 2;

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
          // Lingkaran kecil dengan stroke keluar, center horizontal kamera
          Positioned(
            left: (screenWidth - (circleSize + 2 * stroke)) / 2,
            top: navbarTop - (circleSize / 2) - stroke,
            child: Container(
              width: circleSize + 2 * stroke,
              height: circleSize + 2 * stroke,
              decoration: const BoxDecoration(
                color: Color(0xFF6DC61A), // Stroke hijau muda
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFF006D00), // Fill hijau tua
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
                color: const Color(0xFF6DC61A), // Hijau muda
              ),
            ),
          ),
          // Icon Home (tengah-tengah setengah kiri box)
          Positioned(
            left: (screenWidth / 4) - (iconSize / 2),
            top: iconTop,
            child: Icon(
              Icons.home_rounded,
              size: iconSize,
              color: const Color(0xFF006D00),
            ),
          ),
          // Icon Person (tengah-tengah setengah kanan box)
          Positioned(
            left: (screenWidth * 3 / 4) - (iconSize / 2),
            top: iconTop,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: Icon(
                Icons.person_rounded,
                size: iconSize,
                color: const Color(0xFF006D00),
              ),
            ),
          ),
          // Box hijau
          Positioned(
            left: boxLeft,
            top: boxTop,
            child: Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF6DC61A),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          // Gambar tomat
          Positioned(
            left: tomatoLeft,
            top: tomatoTop,
            child: Image.asset(
              'assets/images/tomato_profile.png',
              width: tomatoSize,
              height: tomatoSize,
            ),
          ),
          // Tulisan Welcome, Tommy (benar-benar center vertikal)
          Positioned(
            left: textLeft,
            top: textTop,
            child: SizedBox(
              width: boxWidth - (115 / 393 * screenWidth) - 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: textLineHeight,
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final username = context.watch<ProfileProvider>().username;
                      // Cek apakah username terlalu panjang untuk 1 baris
                      final maxWidth = constraints.maxWidth;
                      final defaultStyle = TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        height: textLineHeight,
                      );
                      final smallStyle = defaultStyle.copyWith(fontSize: textFontSize * 0.75);

                      // Widget untuk cek lebar username
                      final textPainter = TextPainter(
                        text: TextSpan(text: username, style: defaultStyle),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: maxWidth);

                      final useSmallFont = textPainter.didExceedMaxLines;

                      return Text(
                        username,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: useSmallFont ? smallStyle : defaultStyle,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Judul News
          Positioned(
            left: 35 / 393 * screenWidth,
            top: 272 / 852 * screenHeight,
            child: Text(
              "News",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: responsiveFont(40),
                fontWeight: FontWeight.w500, // Medium
                color: Colors.black,
                height: 1.0,
              ),
            ),
          ),
          // News Box 1
          Positioned(
            left: box1Left,
            top: box1Top,
            child: _NewsBox(
              width: newsBoxWidth,
              height: newsBoxHeight,
              radius: newsBoxRadius,
              image: 'assets/images/news1.png',
              newsTitle: 'Spotting Tomato Troubles: Identifying Leaf Disease',
              newsTitleLeft: newsTitleLeft,
              newsTitleTop: newsTitleTop,
              newsTitleFontSize: newsTitleFontSize,
              newsTitleLineHeight: newsTitleLineHeight,
              readMoreLeft: readMoreLeft,
              readMoreTop: readMoreTop,
              newsImageHeight: newsImageHeight,
            ),
          ),
          // News Box 2
          Positioned(
            left: box2Left,
            top: box2Top,
            child: _NewsBox(
              width: newsBoxWidth,
              height: newsBoxHeight,
              radius: newsBoxRadius,
              image: 'assets/images/news2.png',
              newsTitle: 'The Look of a Healthy Tomato Leaf',
              newsTitleLeft: newsTitleLeft,
              newsTitleTop: newsTitleTop,
              newsTitleFontSize: newsTitleFontSize,
              newsTitleLineHeight: newsTitleLineHeight,
              readMoreLeft: readMoreLeft,
              readMoreTop: readMoreTop,
              newsImageHeight: newsImageHeight,
            ),
          ),
          // News Box 3
          Positioned(
            left: box3Left,
            top: box3Top,
            child: _NewsBox(
              width: newsBoxWidth,
              height: newsBoxHeight,
              radius: newsBoxRadius,
              image: 'assets/images/news1.png',
              newsTitle: 'Essential Tomato Plant Care Tips',
              newsTitleLeft: newsTitleLeft,
              newsTitleTop: newsTitleTop,
              newsTitleFontSize: newsTitleFontSize,
              newsTitleLineHeight: newsTitleLineHeight,
              readMoreLeft: readMoreLeft,
              readMoreTop: readMoreTop,
              newsImageHeight: newsImageHeight,
            ),
          ),
          // News Box 4
          Positioned(
            left: box4Left,
            top: box4Top,
            child: _NewsBox(
              width: newsBoxWidth,
              height: newsBoxHeight,
              radius: newsBoxRadius,
              image: 'assets/images/news3.png',
              newsTitle: 'Recognizing Bacterial Spot on Leaves',
              newsTitleLeft: newsTitleLeft,
              newsTitleTop: newsTitleTop,
              newsTitleFontSize: newsTitleFontSize,
              newsTitleLineHeight: newsTitleLineHeight,
              readMoreLeft: readMoreLeft,
              readMoreTop: readMoreTop,
              newsImageHeight: newsImageHeight,
            ),
          ),
          // Navbar di paling akhir agar selalu di bawah
          const CustomNavbar(selectedIndex: 0),
        ],
      ),
    );
  }
}

class _NewsBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String image;
  final String newsTitle;
  final double newsTitleLeft;
  final double newsTitleTop;
  final double newsTitleFontSize;
  final double newsTitleLineHeight;
  final double readMoreLeft;
  final double readMoreTop;
  final double newsImageHeight;

  const _NewsBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.image,
    required this.newsTitle,
    required this.newsTitleLeft,
    required this.newsTitleTop,
    required this.newsTitleFontSize,
    required this.newsTitleLineHeight,
    required this.readMoreLeft,
    required this.readMoreTop,
    required this.newsImageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double responsiveFont(double figmaFont) => figmaFont * screenWidth / 393;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          // Gambar atas
          Positioned(
            left: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              ),
              child: Image.asset(
                image,
                width: width,
                height: newsImageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Box hijau bawah
          Positioned(
            left: 0,
            top: newsImageHeight,
            child: Container(
              width: width,
              height: height - newsImageHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF6DC61A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
            ),
          ),
          // Judul News
          Positioned(
            left: newsTitleLeft,
            top: newsTitleTop,
            child: Text(
              newsTitle,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: newsTitleFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: newsTitleLineHeight,
              ),
            ),
          ),
          // Read more...
          Positioned(
            left: readMoreLeft,
            top: readMoreTop,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: const Color(0xFFC9F2A8).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: 320 / 393 * screenWidth,
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsTitle,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: responsiveFont(16),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getNewsContent(newsTitle),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: responsiveFont(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Opacity(
                opacity: 0.75,
                child: Text(
                  "read more...",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: newsTitleFontSize,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    height: newsTitleLineHeight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNewsContent(String title) {
    // TODO: Ganti dengan konten berita yang sesuai
    switch (title) {
      case 'Spotting Tomato Troubles: Identifying Leaf Disease':
        return 'Early detection of diseases is crucial for a healthy tomato harvest. Keep a close watch on your tomato leaves for tell-tale signs such as yellowing, dark spots, wilting, or unusual patterns like mosaics or rings. Notice if the spots are wet-looking, dry, or have a specific color or border. Identifying whether the issue starts on older or younger leaves can also provide clues. Comparing suspicious leaves with images from reliable gardening resources or using a plant disease identification app can help pinpoint the problem, allowing for swift and appropriate action before the disease spreads.';
      case 'The Look of a Healthy Tomato Leaf':
        return "A healthy tomato leaf is a vibrant sign of a thriving plant. Typically, it should exhibit a rich, uniform green color, although the exact shade can vary slightly depending on the variety. The leaf surface should feel relatively smooth and look turgid, not wilted or droopy. Crucially, a healthy leaf will be free from spots, holes, yellow or brown patches, powdery residues, or any form of distortion or curling, indicating it's efficiently performing photosynthesis and contributing to the plant;'s overall growth and fruit production.";
      case 'Essential Tomato Plant Care Tips':
        return 'Caring for tomato plants involves providing their fundamental needs to ensure vigorous growth and a bountiful yield. Plant them in a location that receives at least 6-8 hours of direct sunlight daily and in well-draining, nutrient-rich soil. Consistent watering is key – aim to keep the soil evenly moist but not waterlogged, watering at the base to avoid wetting the leaves. As they grow, provide support like stakes or cages, fertilize regularly according to package directions, and practice good garden hygiene to minimize pest and disease risks.';
      case 'Recognizing Bacterial Spot on Leaves':
        return 'Bacterial Spot is a common and troublesome tomato disease, especially in warm, humid conditions. It first appears on leaves as small, water-soaked, almost greasy-looking spots, typically less than 3mm in diameter. These spots soon darken, turning black or dark brown, and often develop a yellow halo around them. As the disease progresses, these spots can merge, causing larger areas of the leaf to yellow and eventually die, sometimes leading to the center of the spots falling out, giving a "shot-hole" appearance.';
      default:
        return 'No content available';
    }
  }
}

