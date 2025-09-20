import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/helper_service.dart';


class AuthProvider extends ChangeNotifier {
  String? token;

  bool get isLoggedIn => token != null;
  bool initialized = false;

  AuthProvider() {
    _loadToken(); // Load token on app start
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    initialized = true;
    notifyListeners();
  }

  Future<void> _saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", newToken);
    token = newToken;
    notifyListeners();
  }


  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("https://reqres.in/api/login"),
      body: jsonEncode({"email": email, "password": password}),
      headers:  {
        'Content-Type': 'application/json',
        "x-api-key": "reqres-free-v1"
      },
    );
    if (response.statusCode == 200) {
     final newToken = jsonDecode(response.body)['token'];
      await _saveToken(newToken);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username,String email, String password) async {
   // Uri url= Uri.parse("https://reqres.in/api/register");
    final response = await http.post(
      Uri.parse("https://reqres.in/api/register"),
      body:  jsonEncode({"username":username, "email": email, "password": password}),
      // headers: HelperService.buildHeaders(url)
      headers:  {
        'Content-Type': 'application/json',
        "x-api-key": "reqres-free-v1"
      },
    );
    if (response.statusCode == 200) {
     final newToken = jsonDecode(response.body)['token'];
      await _saveToken(newToken);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    token = null;
    notifyListeners();
  }
}
