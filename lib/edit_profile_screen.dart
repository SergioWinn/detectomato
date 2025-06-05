import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _biodataController;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    _usernameController = TextEditingController(text: profile.username);
    _biodataController = TextEditingController(text: profile.biodata);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _biodataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          // Tomat besar di tengah
          Positioned(
            left: (screenWidth - 180) / 2,
            top: 100,
            child: Image.asset(
              'assets/images/tomato_profile.png',
              width: 180,
              height: 180,
            ),
          ),
          // Username field
          Positioned(
            left: 32,
            top: 320,
            right: 32,
            child: Row(
              children: [
                const Icon(Icons.person, size: 32, color: Colors.black),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Biodata field
          Positioned(
            left: 32,
            top: 380,
            right: 32,
            child: Row(
              children: [
                const Icon(Icons.info, size: 32, color: Colors.black),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _biodataController,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tombol simpan
          Positioned(
            left: 32,
            right: 32,
            bottom: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6DC61A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                final newUsername = _usernameController.text.trim();
                final newBiodata = _biodataController.text.trim();

                // Ambil email dari ProfileProvider
                final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                final email = profileProvider.email;

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Session expired. Please sign in again.')),
                  );
                  return;
                }

                try {
                  // Update ke tabel users berdasarkan email
                  final updateResult = await Supabase.instance.client
                      .from('users')
                      .update({
                        'username': newUsername,
                        'biodata': newBiodata,
                      })
                      .eq('email', email)
                      .select();

                  print('Update result: $updateResult');

                  // Update ke provider lokal
                  profileProvider.updateUsername(newUsername);
                  profileProvider.updateBiodata(newBiodata);

                  Navigator.pop(context);
                } catch (e) {
                  print('Update error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update profile: $e')),
                  );
                  return;
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
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