import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const jsonPlaceholderBase = "https://jsonplaceholder.typicode.com";
  static const userUrl = "https://reqres.in/api/users";

  static Future<List<dynamic>> getUsers() async {
    final res = await http.get(Uri.parse("$userUrl/users"), headers: {"x-api-key": "reqres-free-v1"});
    return jsonDecode(res.body)["data"];
  }

  static Future<Map<String, dynamic>> getUser(int id) async {
    final res = await http.get(
      Uri.parse("$userUrl/$id"),
      headers: {"x-api-key": "reqres-free-v1"},
    );
    return jsonDecode(res.body)["data"];
  }

  static Future<Map<String, dynamic>> createTask(String title) async {
    final res = await http.post(
      Uri.parse("$jsonPlaceholderBase/todos"),
      body: jsonEncode({"title": title, "completed": false, "userId": 1}),
      headers: {"Content-Type": "application/json",
        "x-api-key": "reqres-free-v1"
      },
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateTask(int id, bool completed) async {
    final res = await http.put(
      Uri.parse("$jsonPlaceholderBase/todos/$id"),
      body: jsonEncode({"completed": completed}),
      headers: {"Content-Type": "application/json",
        "x-api-key": "reqres-free-v1"
      },
    );
    return jsonDecode(res.body);
  }

  static Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse("$jsonPlaceholderBase/todos/$id"),
      headers: {"Content-Type": "application/json",
        "x-api-key": "reqres-free-v1"
      },
    );
  }
}
