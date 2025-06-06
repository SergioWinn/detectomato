import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart';
import 'profile_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double responsiveFont(double figmaFont) => figmaFont * screenWidth / 393;

    return Scaffold(
      backgroundColor: const Color(0xFFDFFDC9), // Warna latar belakang hijau muda
      body: Stack(
        children: [
          // Judul "Sign Up"
          Align(
            alignment: Alignment(0, -1 + (200 / 852) * 2), // Posisi Y dihitung relatif
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: responsiveFont(40), // Ukuran font sesuai spesifikasi
                fontWeight: FontWeight.bold, // Bold
                color: Colors.black, // Warna hitam
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Box Input Email
          Positioned(
            left: 40 / 393 * screenWidth, // Posisi X
            top: 274 / 852 * screenHeight, // Posisi Y
            child: Container(
              width: 313 / 393 * screenWidth, // Lebar box
              height: 50 / 852 * screenHeight, // Tinggi box
              decoration: BoxDecoration(
                color: const Color(0xFF6DC61A), // Warna hijau
                borderRadius: BorderRadius.circular(15), // Corner radius 15
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: responsiveFont(16),
                  fontWeight: FontWeight.w500, // Medium
                  color: Colors.black, // Warna hitam untuk input
                ),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: responsiveFont(16),
                    fontWeight: FontWeight.w500, // Medium
                    color: Colors.black, // Warna hitam untuk placeholder
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 20, // Posisi X tulisan
                    top: 15, // Posisi Y tulisan
                    bottom: 10, // Sesuaikan agar teks benar-benar di tengah
                  ),
                  border: InputBorder.none, // Hilangkan border default
                ),
              ),
            ),
          ),
          // Box Input Username
          Positioned(
            left: 40 / 393 * screenWidth, // Posisi X
            top: 348 / 852 * screenHeight, // Posisi Y
            child: Container(
              width: 313 / 393 * screenWidth, // Lebar box
              height: 50 / 852 * screenHeight, // Tinggi box
              decoration: BoxDecoration(
                color: const Color(0xFF6DC61A), // Warna hijau
                borderRadius: BorderRadius.circular(15), // Corner radius 15
              ),
              child: TextField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: responsiveFont(16),
                  fontWeight: FontWeight.w500, // Medium
                  color: Colors.black, // Warna hitam untuk input
                ),
                decoration: InputDecoration(
                  hintText: 'Username (min. 5 characters)',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: responsiveFont(16),
                    fontWeight: FontWeight.w500, // Medium
                    color: Colors.black, // Warna hitam untuk placeholder
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 20, // Posisi X tulisan
                    top: 15, // Posisi Y tulisan
                    bottom: 10, // Sesuaikan agar teks benar-benar di tengah
                  ),
                  border: InputBorder.none, // Hilangkan border default
                ),
              ),
            ),
          ),
          // Box Input Password
          Positioned(
            left: 40 / 393 * screenWidth, // Posisi X
            top: 422 / 852 * screenHeight, // Posisi Y
            child: Container(
              width: 313 / 393 * screenWidth, // Lebar box
              height: 50 / 852 * screenHeight, // Tinggi box
              decoration: BoxDecoration(
                color: const Color(0xFF6DC61A), // Warna hijau
                borderRadius: BorderRadius.circular(15), // Corner radius 15
              ),
              child: TextField(
                controller: _passwordController, // Untuk input password
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: responsiveFont(16),
                  fontWeight: FontWeight.w500, // Medium
                  color: Colors.black, // Warna hitam untuk input
                ),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: responsiveFont(16),
                    fontWeight: FontWeight.w500, // Medium
                    color: Colors.black, // Warna hitam untuk placeholder
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 20, // Posisi X tulisan
                    top: 15, // Posisi Y tulisan
                    bottom: 10, // Sesuaikan agar teks benar-benar di tengah
                  ),
                  border: InputBorder.none, // Hilangkan border default
                ),
              ),
            ),
          ),
          // Box Input Confirm Password
          Positioned(
            left: 40 / 393 * screenWidth, // Posisi X
            top: 496 / 852 * screenHeight, // Posisi Y
            child: Container(
              width: 313 / 393 * screenWidth, // Lebar box
              height: 50 / 852 * screenHeight, // Tinggi box
              decoration: BoxDecoration(
                color: const Color(0xFF6DC61A), // Warna hijau
                borderRadius: BorderRadius.circular(15), // Corner radius 15
              ),
              child: TextField(
                controller: _confirmPasswordController, // Untuk input password
                obscureText: true,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: responsiveFont(16),
                  fontWeight: FontWeight.w500, // Medium
                  color: Colors.black, // Warna hitam untuk input
                ),
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: responsiveFont(16),
                    fontWeight: FontWeight.w500, // Medium
                    color: Colors.black, // Warna hitam untuk placeholder
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 20, // Posisi X tulisan
                    top: 15, // Posisi Y tulisan
                    bottom: 10, // Sesuaikan agar teks benar-benar di tengah
                  ),
                  border: InputBorder.none, // Hilangkan border default
                ),
              ),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Positioned(
              left: 40,
              right: 40,
              top: 550 / 852 * screenHeight,
              child: Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: responsiveFont(14),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          // Teks "Already have an account? Sign in here"
          Positioned(
            left: 35,
            right: 35,
            top: 570 / 852 * screenHeight, // Posisi Y
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: responsiveFont(16), // Ukuran font sesuai permintaan
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black, // Warna hitam
                    ),
                  ),
                  TextSpan(
                    text: 'Sign in here',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: responsiveFont(16), // Ukuran font sesuai permintaan
                      fontWeight: FontWeight.bold, // Bold
                      color: Colors.black, // Warna hitam
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 300), // Durasi animasi 300ms
                            pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const curve = Curves.easeOut; // Kurva ease out
                              final curvedAnimation = CurvedAnimation(
                                parent: animation,
                                curve: curve,
                              );
                              return FadeTransition(
                                opacity: curvedAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
          // Tombol "Sign Up"
          Positioned(
            left: 40 / 393 * screenWidth, // Posisi X
            top: 605 / 852 * screenHeight, // Posisi Y
            child: GestureDetector(
              onTap: _isLoading ? null : _signUp,
                child: Container(
                  width: 313 / 393 * screenWidth, // Lebar tombol
                  height: 50 / 852 * screenHeight, // Tinggi tombol
                  decoration: BoxDecoration(
                    color: const Color(0xFF6DC61A), // Warna hijau
                    borderRadius: BorderRadius.circular(15), // Corner radius 15
                  ),
                  child: Center(
                    child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: responsiveFont(16),
                          fontWeight: FontWeight.bold, // Bold
                          color: Colors.black, // Warna hitam
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),
                ),
            )
          ),
        ],
      ),
    );
  }
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validasi input
    if (email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required';
        _isLoading = false;
      });
      return;
    }

    if (username.length < 5) {
      setState(() {
        _errorMessage = 'Username must be at least 5 characters';
        _isLoading = false;
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        _errorMessage = 'Password must be at least 8 characters';
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
        _isLoading = false;
      });
      return;
    }

    final supabase = Supabase.instance.client;
    try {
      // Cek apakah email sudah terdaftar
      final existing = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (existing != null) {
        setState(() {
          _errorMessage = 'Email already registered';
          _isLoading = false;
        });
        return;
      }

      // Insert user baru ke tabel users
      await supabase.from('users').insert({
        'email': email,
        'password': password, // Untuk produksi, WAJIB di-hash!
        'username': username,
        'biodata': 'I love tomatoes!',
      });

      // Update ProfileProvider
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.updateEmail(email);
      profileProvider.updateUsername(username);
      profileProvider.updateBiodata('I love tomatoes!');

      // Tambahkan baris ini agar userId terisi!
      await profileProvider.fetchUserProfile();

      // Navigasi ke HomeScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign up failed. Please check your data.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }
}