import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? user;
  bool loading = false;

  Future<void> fetchAllUser() async {
    loading = true;
    notifyListeners();

    final response = await http.get(Uri.parse("https://reqres.in/api/users"),
      headers:  {
        'Content-Type': 'application/json',
        "x-api-key": "reqres-free-v1"
      },
    );
    if (response.statusCode == 200) {
      user = UserProfile.fromJson(jsonDecode(response.body));
    }
    loading = false;
    notifyListeners();
  }


  Future<void> fetchUser(int id) async {
    loading = true;
    notifyListeners();

    final response = await http.get(Uri.parse("https://reqres.in/api/users/$id"),
      headers:  {
        'Content-Type': 'application/json',
        "x-api-key": "reqres-free-v1"
      },
    );
    if (response.statusCode == 200) {
      user = UserProfile.fromJson(jsonDecode(response.body));
    }
    loading = false;
    notifyListeners();
  }
}
