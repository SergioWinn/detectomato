import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'home_screen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'profile_provider.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  CameraController? _controller;
  XFile? _capturedImage;
  int step = 0;
  late List<CameraDescription> _cameras;
  bool isLoading = false;
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _modelLoaded = false;
  String? _resultLabel;

  final Map<String, String> _diseaseInfo = {
    'Bacterial Spot': 'To manage Bacterial Spot, infected plants and plant debris should be promptly removed and destroyed to prevent further spread. It is essential to apply copper-based fungicides regularly, especially during humid or rainy conditions. Using disease-free seeds and resistant tomato varieties can significantly reduce the risk. Crop rotation is recommended, avoiding planting tomatoes or peppers in the same location for at least two years. Additionally, overhead watering should be minimized to reduce leaf wetness, which facilitates bacterial spread.',
    'Early Blight': 'Effective treatment of Early Blight involves removing infected leaves and avoiding watering from above, which can spread spores. Fungicides containing chlorothalonil, mancozeb, or copper compounds should be applied early in the season as a preventive measure. Planting resistant varieties and practicing crop rotation also help control the disease. Applying mulch around the base of the plants can prevent soil from splashing onto leaves, and ensuring adequate spacing improves air circulation, which discourages fungal growth.',
    'Late Blight': 'Late Blight requires immediate action; infected plants must be destroyed as soon as symptoms appear. Fungicides containing mefenoxam or fluopicolide are effective treatments. Farmers should avoid planting tomatoes near potatoes, which can also host the disease. Monitoring weather conditions and applying protective fungicides before an outbreak can reduce damage. Choosing late blight-resistant tomato cultivars further helps in managing this severe disease.',
    'Leaf Mold': 'Leaf Mold thrives in humid conditions, so improving ventilation and reducing humidity is crucial, especially in greenhouses or dense plantings. Sulfur or copper-based fungicides should be applied preventively. Watering at the base of the plant helps keep foliage dry, and removing affected leaves limits the spread. Cultivating resistant tomato varieties is also an effective long-term strategy.',
    'Septoria leaf spot': 'Managing Septoria Leaf Spot involves removing infected foliage and avoiding overhead watering. Applying fungicides such as chlorothalonil or mancozeb can control the spread. Good cultural practices like proper plant spacing, crop rotation, and using clean seeds help minimize infection. Mulching around the base of plants also prevents fungal spores from splashing onto lower leaves from the soil.',
    'Spider mites Two-spotted spider mite': 'Spider mites can be controlled by spraying plants with water to dislodge them and increase humidity, which they dislike. Insecticidal soaps or specific miticides can be used if infestations become severe. Introducing natural predators like ladybugs or predatory mites is also effective. Severely infested leaves should be removed, and nitrogen fertilization should be moderated since excess nitrogen encourages mite populations.',
    'Target Spot': 'For Target Spot, it is important to remove infected plant parts and maintain cleanliness in the garden or farm. Preventive fungicides such as azoxystrobin or chlorothalonil can be applied to protect healthy leaves. Ensuring good air circulation through proper spacing and pruning, rotating crops, and watering at the soil level are essential practices to manage the disease effectively.',
    'Tomato Yellow Leaf Curl Virus': 'TYLCV is a viral disease transmitted by whiteflies, so controlling these insects is critical. Infected plants must be destroyed immediately to prevent the virus from spreading. Using insect-proof netting, reflective mulches, and resistant varieties can greatly reduce incidence. Farmers should avoid planting tomatoes near previously infected areas and monitor crops closely for signs of infestation.',
    'Tomato mosaic virus': 'Tomato Mosaic Virus spreads through contact, so sanitation is key. Infected plants should be removed and tools must be disinfected with a bleach solution. Gardeners and farmers should avoid smoking or handling tobacco near tomato plants, as the virus can be carried from cigarettes. Using virus-free seeds and resistant cultivars, along with strict hygiene practices, can effectively reduce infection rates.',
    'Healthy': 'To maintain healthy tomato plants, consistent and preventive care is essential. This includes regular monitoring for signs of disease, practicing crop rotation, ensuring proper plant spacing, and using disease-resistant varieties. Balanced fertilization and watering at the base of the plants help maintain vigor and reduce disease risk. Mulching and proper sanitation further contribute to long-term plant health.',
    'Powdery Mildew': 'Powdery Mildew can be controlled by applying sulfur-based or potassium bicarbonate fungicides. It\'s important to prune overcrowded plants to improve airflow and reduce humidity. Watering at the base keeps leaves dry, which discourages fungal growth. Removing infected leaves early and ensuring adequate sunlight also help prevent the disease from spreading.',
  };

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadModel();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model_ResNet50.tflite');
    _labels = await _loadLabels('assets/labels.txt');
    setState(() {
      _modelLoaded = true;
    });
  }

  Future<List<String>> _loadLabels(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  // Preprocessing manual tanpa helper
  Future<void> _predict(File imageFile) async {
    // 1. Baca file gambar dan decode
    final bytes = await imageFile.readAsBytes();
    img.Image? oriImage = img.decodeImage(bytes);
    if (oriImage == null) return;

    // 2. Resize ke 224x224
    img.Image resized = img.copyResize(oriImage, width: 224, height: 224);

    // 3. Normalisasi ke 0-1 dan ubah ke Float32List
    var input = Float32List(1 * 224 * 224 * 3);
    int index = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        final r = (pixel >> 16) & 0xFF;
        final g = (pixel >> 8) & 0xFF;
        final b = pixel & 0xFF;
        input[index++] = r / 255.0;
        input[index++] = g / 255.0;
        input[index++] = b / 255.0;
      }
    }

    // 4. Bentuk input ke [1, 224, 224, 3]
    var inputTensor = input.reshape([1, 224, 224, 3]);

    // 5. Siapkan output buffer (jumlah kelas = _labels.length)
    var output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);

    // 6. Run inference
    _interpreter.run(inputTensor, output);

    // 7. Ambil hasil prediksi
    int maxIndex = 0;
    double maxScore = output[0][0];
    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > maxScore) {
        maxScore = output[0][i];
        maxIndex = i;
      }
    }

    setState(() {
      _resultLabel = _labels.isNotEmpty ? _labels[maxIndex] : 'Class $maxIndex';
    });
  }

  Future<String?> uploadImageToSupabase(File imageFile) async {
    final supabase = Supabase.instance.client;
    final fileName = 'detection_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storagePath = 'detections/$fileName';

    final bytes = await imageFile.readAsBytes();

    final response = await supabase.storage
        .from('detectomato.history') // ganti dengan nama bucket Anda
        .uploadBinary(storagePath, bytes, fileOptions: const FileOptions(upsert: true));

    if (response != null && response.isNotEmpty) {
      // Dapatkan public URL
      final publicUrl = supabase.storage.from('detectomato.history').getPublicUrl(storagePath);
      return publicUrl;
    }
    return null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double responsiveFont(double figmaFont) => figmaFont * screenWidth / 393;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Step 0: Camera preview
          if (step == 0 && _controller != null && _controller!.value.isInitialized)
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),
          // Step 0: Tombol kamera
          if (step == 0 && _controller != null && _controller!.value.isInitialized)
            Positioned(
              left: (screenWidth - 72) / 2,
              bottom: 48,
              child: GestureDetector(
                onTap: () async {
                  final image = await _controller!.takePicture();
                  setState(() {
                    _capturedImage = image;
                    step = 1;
                  });
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                ),
              ),
            ),
          // Step 0: Tombol pilih dari galeri
          if (step == 0 && _controller != null && _controller!.value.isInitialized)
            Positioned(
              left: (screenWidth - 72) / 2,
              bottom: 130,
              child: GestureDetector(
                onTap: () async {
                  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      _capturedImage = XFile(picked.path);
                      step = 1;
                    });
                  }
                },
                child: Container(
                  width: 72,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(Icons.photo_library, color: Colors.white),
                  ),
                ),
              ),
            ),
          // Step 1: Preview hasil foto + tombol Detect Now
          if (step == 1 && _capturedImage != null)
            Positioned.fill(
              child: Image.file(
                File(_capturedImage!.path),
                fit: BoxFit.cover,
              ),
            ),
          // Step 1: Tombol Detect Now
          if (step == 1 && _capturedImage != null)
            Positioned(
              left: 109 / 393 * screenWidth,
              top: 692 / 852 * MediaQuery.of(context).size.height,
              child: SizedBox(
                width: 175.8 / 393 * screenWidth,
                height: 60 / 852 * MediaQuery.of(context).size.height,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6DC61A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await _predict(File(_capturedImage!.path));
                    final imageUrl = await uploadImageToSupabase(File(_capturedImage!.path));

                    // Ambil userId dari ProfileProvider
                    final userId = Provider.of<ProfileProvider>(context, listen: false).userId;
                    print('userId yang dikirim: $userId'); // Debug

                    if (userId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User ID tidak ditemukan. Silakan login ulang.')),
                      );
                      setState(() {
                        isLoading = false;
                      });
                      return;
                    }

                    await Supabase.instance.client.from('detection_history').insert({
                      'user_id': userId,
                      'image_url': imageUrl,
                      'result_label': _resultLabel,
                      'detected_at': DateTime.now().toIso8601String(),
                    });

                    setState(() {
                      isLoading = false;
                      step = 2;
                    });
                  },
                  child: Center(
                    child: Text(
                      'Detect Now',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: responsiveFont(21.6),
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          // Step 2: Result
          if (step == 2 && _capturedImage != null) ...[
            // Blur background
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                child: Image.file(
                  File(_capturedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Box result
            Positioned(
              left: 35 / 393 * screenWidth,
              top: 646 / 852 * MediaQuery.of(context).size.height,
              child: Container(
                width: 323 / 393 * screenWidth,
                height: 100 / 852 * MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9F2A8).withOpacity(0.75),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            // Gambar tomat (x=15, y=center box)
            Positioned(
              left: 35 / 393 * screenWidth + 15,
              top: 646 / 852 * MediaQuery.of(context).size.height +
                  (100 / 852 * MediaQuery.of(context).size.height - 82.3 / 393 * screenWidth) / 2,
              child: Image.asset(
                'assets/images/tomato_profile.png',
                width: 82.3 / 393 * screenWidth,
                height: 82.3 / 393 * screenWidth,
              ),
            ),
            // Nama penyakit hasil prediksi (DYNAMIC)
            Positioned(
              left: 35 / 393 * screenWidth + 110,
              top: 646 / 852 * MediaQuery.of(context).size.height + 20,
              child: Text(
                _resultLabel ?? 'Detecting...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveFont(20),
                  color: Colors.black,
                ),
              ),
            ),
            // Read more (static, bisa Anda buat dinamis jika ingin)
            Positioned(
              left: 35 / 393 * screenWidth + 110,
              top: 646 / 852 * MediaQuery.of(context).size.height + 55,
              child: Opacity(
                opacity: 0.5,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: const Color(0xFFC9F2A8).withOpacity(0.75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: 320 / 393 * screenWidth,
                          padding: const EdgeInsets.all(24),
                          child: SingleChildScrollView(
                            child: Text(
                              _diseaseInfo[_resultLabel ?? ''] ?? 'No information available.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: responsiveFont(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'read more...',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: responsiveFont(16),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
          // Step 1 & 2: Tombol back
          if (step == 1 || step == 2)
            Positioned(
              left: 10 / 393 * screenWidth,
              top: 60 / 852 * MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (step == 2) {
                      step = 0;
                      _resultLabel = null; // reset hasil prediksi
                    } else {
                      step = 0;
                      _resultLabel = null;
                    }
                  });
                },
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
          // Step 0: Tombol back di pojok kiri atas
          if (step == 0)
            Positioned(
              left: 10 / 393 * screenWidth,
              top: 60 / 852 * MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
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
          // Loading indicator
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6DC61A),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}