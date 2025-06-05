import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';
import 'home_screen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';

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
    _interpreter = await Interpreter.fromAsset('model_ResNet50.tflite');
    _labels = await FileUtil.loadLabels('assets/labels.txt');
    setState(() {
      _modelLoaded = true;
    });
  }

  Future<void> _predict(File imageFile) async {
    // 1. Baca gambar dan resize ke 224x224 (atau sesuai input model)
    final image = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOR))
        .build()
        .process(
          TensorImage.fromFile(imageFile),
        );

    // 2. Normalisasi (jika model Anda butuh, misal 0-1)
    var input = image.buffer; // pastikan sesuai input model Anda

    // 3. Siapkan output buffer
    var output = List.filled(1 * 1000, 0.0).reshape([1, 1000]); // 1000 = jumlah kelas

    // 4. Run inference
    _interpreter.run(input, output);

    // 5. Ambil hasil prediksi
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
              bottom: 130, // Atur jarak di atas tombol kamera
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
                    setState(() {
                      isLoading = false;
                      step = 2;
                    });
                  },
                  child: const Center(
                    child: Text(
                      'Detect Now',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600, // Semi bold
                        fontSize: 21.6,
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
              left: 35 / 393 * screenWidth + 15, // 35 = box left, 15 = margin dalam box
              top: 646 / 852 * MediaQuery.of(context).size.height +
                  (100 / 852 * MediaQuery.of(context).size.height - 82.3 / 393 * screenWidth) / 2,
              child: Image.asset(
                'assets/images/tomato_profile.png',
                width: 82.3 / 393 * screenWidth,
                height: 82.3 / 393 * screenWidth,
              ),
            ),
            // Nama penyakit (x=110, y=~20 dari atas box)
            Positioned(
              left: 35 / 393 * screenWidth + 110,
              top: 646 / 852 * MediaQuery.of(context).size.height + 20,
              child: const Text(
                'Bacterial Spot',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            // Read more (x=110, y=~55 dari atas box)
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Before planting:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Do not plant successive crops of tomatoes on the land or in the same garden; use a 3-year crop rotation.\n'
                                  '• Do not plant new crops next to those that have the disease; otherwise spread of the disease to the new crop will be rapid and significant.\n'
                                  '• It is not known for certain whether seed is important in the spread of the fungus. However, hot water treatment has been used as a method of producing seed free from contamination by fungal spores. Seed is treated with water for 25 minutes at exactly 50°C. Note, this is not a method that farmers would use, because of the need for a thermometer. Also, treatment of seed by this method would only be done as a last resort, after other methods have been tried and failed.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'During growth:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Remove infected lower leaves as soon as the first three or four fruit trusses (bunches) have been picked.\n'
                                  '• Do not use overhead irrigation; otherwise, it will create conditions for spore production and infection.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'After harvest:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Collect plant remains and burn them, or dig them deeply into the soil.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'read more...',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
          // Step 1 & 2: Tombol back (arrow style sama seperti arrow_next di onboarding)
          if (step == 1 || step == 2)
            Positioned(
              left: 10 / 393 * screenWidth,
              top: 60 / 852 * MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () => setState(() => step == 2 ? step = 1 : step = 0),
                child: Container(
                  width: 40 / 393 * screenWidth,
                  height: 40 / 393 * screenWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6DC61A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded, // style sama seperti arrow_next
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
          // Result label
          if (step == 2 && _resultLabel != null)
            Positioned(
              left: 35 / 393 * screenWidth + 110,
              top: 646 / 852 * MediaQuery.of(context).size.height + 20,
              child: Text(
                _resultLabel ?? 'Detecting...',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}