import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  String _username = '';
  String _email = '';
  String _biodata = 'I love tomatoes!';

  String get username => _username;
  String get email => _email;
  String get biodata => _biodata;

  void updateUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updateBiodata(String biodata) {
    _biodata = biodata;
    notifyListeners();
  }

  void reset() {
    _username = '';
    _email = '';
    _biodata = 'I love tomatoes!';
    notifyListeners();
  }

  /// Ambil profile user dari tabel users berdasarkan email yang sudah login
  Future<void> fetchUserProfile() async {
    if (_email.isEmpty) return; // pastikan email sudah di-set saat login
    final response = await Supabase.instance.client
        .from('users')
        .select('username, biodata, email')
        .eq('email', _email)
        .maybeSingle();
    if (response != null) {
      updateEmail(response['email'] ?? '');
      updateUsername(response['username'] ?? '');
      updateBiodata(response['biodata'] ?? 'I love tomatoes!');
    }
  }
}