import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  String _userId = ''; // Tambahkan ini
  String _username = '';
  String _email = '';
  String _biodata = 'I love tomatoes!';

  String get userId => _userId; // Tambahkan getter ini
  String get username => _username;
  String get email => _email;
  String get biodata => _biodata;

  void updateUserId(String userId) { // Tambahkan setter ini
    _userId = userId;
    notifyListeners();
  }

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
    _userId = '';
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
        .select('id, username, biodata, email') // tambahkan 'id'
        .eq('email', _email)
        .maybeSingle();
    print('fetchUserProfile response: $response');
    if (response != null) {
      updateUserId(response['id'] ?? ''); // set userId
      updateEmail(response['email'] ?? '');
      updateUsername(response['username'] ?? '');
      updateBiodata(response['biodata'] ?? 'I love tomatoes!');
      print('userId setelah fetch: $_userId');
    }
  }
}