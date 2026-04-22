// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class LocalHandler {
   setTheme(String theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }

   Future<String> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? action = prefs.getString('theme');
    return action ?? "";
  }

}
