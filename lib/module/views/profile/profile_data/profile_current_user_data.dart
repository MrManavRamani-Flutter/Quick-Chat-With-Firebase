import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  // Get user data from SharedPreferences
  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
