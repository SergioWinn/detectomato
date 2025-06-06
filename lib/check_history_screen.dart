import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_provider.dart';

class DetectionHistory {
  final String imageUrl;
  final String resultLabel;
  final DateTime detectedAt;

  DetectionHistory({
    required this.imageUrl,
    required this.resultLabel,
    required this.detectedAt,
  });

  factory DetectionHistory.fromJson(Map<String, dynamic> json) {
    return DetectionHistory(
      imageUrl: json['image_url'],
      resultLabel: json['result_label'],
      detectedAt: DateTime.parse(json['detected_at']),
    );
  }
}

class CheckHistoryScreen extends StatefulWidget {
  const CheckHistoryScreen({super.key});

  @override
  State<CheckHistoryScreen> createState() => _CheckHistoryScreenState();
}

class _CheckHistoryScreenState extends State<CheckHistoryScreen> {
  late Future<List<DetectionHistory>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = fetchDetectionHistory();
  }

  Future<List<DetectionHistory>> fetchDetectionHistory() async {
    final supabase = Supabase.instance.client;
    final userId = Provider.of<ProfileProvider>(context, listen: false).userId;
    if (userId.isEmpty) return [];
    final response = await supabase
        .from('detection_history')
        .select()
        .eq('user_id', userId) // hanya ambil history user ini
        .order('detected_at', ascending: false);

    if (response == null) return [];
    return (response as List)
        .map((e) => DetectionHistory.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFDFFDC9),
      body: FutureBuilder<List<DetectionHistory>>(
        future: _futureHistory,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final histories = snapshot.data!;
          // Group by month
          final Map<String, List<DetectionHistory>> grouped = {};
          for (var h in histories) {
            final key = '${h.detectedAt.year}-${h.detectedAt.month.toString().padLeft(2, '0')}';
            grouped.putIfAbsent(key, () => []).add(h);
          }
          final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return Stack(
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
              // List history per bulan
              Positioned.fill(
                top: 220 / 852 * screenHeight,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0, bottom: 32),
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, monthIdx) {
                    final key = sortedKeys[monthIdx];
                    final items = grouped[key]!;
                    final date = DateTime.parse('${key.split('-')[0]}-${key.split('-')[1]}-01');
                    final monthName = _monthName(date.month).toUpperCase();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25 / 393 * screenWidth,
                            top: monthIdx == 0 ? 0 : 32,
                            bottom: 8,
                          ),
                          child: Text(
                            monthName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        ...List.generate(items.length, (index) {
                          final h = items[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 25 / 393 * screenWidth,
                              bottom: 16,
                            ),
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
                                // Gambar dari Supabase Storage
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      h.imageUrl,
                                      width: 100 / 852 * screenHeight,
                                      height: 100 / 852 * screenHeight,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                        width: 100 / 852 * screenHeight,
                                        height: 100 / 852 * screenHeight,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                ),
                                // Teks label
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
                                        h.resultLabel,
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
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}