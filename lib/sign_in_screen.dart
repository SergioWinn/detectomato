import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';
import 'profile_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFDFFDC9),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: Stack(
              children: [
                // Judul "Sign In"
                Align(
                  alignment: Alignment(0, -1 + (200 / 852) * 2), // Posisi Y dihitung relatif
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 40, // Ukuran font sesuai spesifikasi
                      fontWeight: FontWeight.bold, // Bold
                      color: Colors.black, // Warna hitam
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Subjudul "Welcome to Detectomato!"
                Positioned(
                  left: 35,
                  right: 35,
                  top: 275 / 852 * screenHeight, // Posisi Y
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Medium
                            color: Colors.black, // Warna hitam
                          ),
                        ),
                        TextSpan(
                          text: 'Detectomato!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold, // Bold
                            fontStyle: FontStyle.italic, // Italic
                            color: Colors.black, // Warna hitam
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Box Input Email (pastikan ini di atas widget lain yang bisa menutupi)
                Positioned(
                  left: 40 / 393 * screenWidth, // Posisi X
                  top: 376 / 852 * screenHeight, // Posisi Y
                  child: Container(
                    width: 313 / 393 * screenWidth, // Lebar box
                    height: 50 / 852 * screenHeight, // Tinggi box
                    decoration: BoxDecoration(
                      color: const Color(0xFF6DC61A), // Warna hijau
                      borderRadius: BorderRadius.circular(15), // Corner radius 15
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress, // Keyboard untuk email
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500, // Medium
                        color: Colors.black, // Warna hitam untuk input
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
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
                  top: 451 / 852 * screenHeight, // Posisi Y
                  child: Container(
                    width: 313 / 393 * screenWidth, // Lebar box
                    height: 50 / 852 * screenHeight, // Tinggi box
                    decoration: BoxDecoration(
                      color: const Color(0xFF6DC61A), // Warna hijau
                      borderRadius: BorderRadius.circular(15), // Corner radius 15
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500, // Medium
                        color: Colors.black, // Warna hitam untuk input
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
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
                    top: 520 / 852 * screenHeight,
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Teks "Don't have an account? Sign up here"
                Positioned(
                  left: 35,
                  right: 35,
                  top: 547 / 852 * screenHeight, // Posisi Y
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16, // Ukuran font sesuai permintaan
                            fontWeight: FontWeight.w500, // Medium
                            color: Colors.black, // Warna hitam
                          ),
                        ),
                        TextSpan(
                          text: 'Sign up here',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16, // Ukuran font sesuai permintaan
                            fontWeight: FontWeight.bold, // Bold
                            color: Colors.black, // Warna hitam
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 300), // Durasi animasi 300ms
                                  pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
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
                // Tombol "Sign In"
                Positioned(
                  left: 40 / 393 * screenWidth, // Posisi X
                  top: 582 / 852 * screenHeight, // Posisi Y
                  child: GestureDetector(
                    onTap: _isLoading ? null : _signIn, // UBAH MENJADI _signIn
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
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold, // Bold
                                  color: Colors.black, // Warna hitam
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Query ke tabel users
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password) // Untuk produksi, WAJIB di-hash!
          .maybeSingle();

      if (response == null) {
        setState(() {
          _errorMessage = 'Email/password salah';
          _isLoading = false;
        });
        return;
      }

      final username = response['username'] ?? '';
      final biodata = response['biodata'] ?? 'I love tomatoes!';

      // Update ProfileProvider
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.updateEmail(email);
      profileProvider.updateUsername(username);
      profileProvider.updateBiodata(biodata);

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
        _errorMessage = 'Sign in failed. Please check your email and password.';
        _isLoading = false;
      });
    }
  }
}