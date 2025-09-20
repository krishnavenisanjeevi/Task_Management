import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:task_management/helper_service.dart';

import '../model/task_model.dart';
import 'notification_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  bool loading = false;

  static const baseUrl ="https://jsonplaceholder.typicode.com/todos";

  Future<void> fetchTasks() async {
    loading = true;
    notifyListeners();

    final response = await http.get(Uri.parse(baseUrl),
    headers: HelperService.buildHeaders(Uri.parse(baseUrl))
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      tasks = data.map((e) => Task.fromApiJson(e)).toList(); // show first 15
    }
    loading = false;
    notifyListeners();
}

  Future<void> addTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: HelperService.buildHeaders(Uri.parse(baseUrl)),
      body: jsonEncode({"title": task.title, "completed": false, "userId": task.userId}),
    );

    if (response.statusCode == 201) {
      final newTask = Task.fromApiJson(jsonDecode(response.body));
      tasks.insert(0, newTask);
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${task.id}"),
      headers: {"Content-Type": "application/json",
      "x-api-key": "reqres-free-v1"
      },
      body: jsonEncode(task.toApiJson()),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    final response =
    await http.delete(Uri.parse("$baseUrl/${task.id}"),
      headers: {"Content-Type": "application/json",
        "x-api-key": "reqres-free-v1"
      },
    );

    if (response.statusCode == 200) {
      tasks.removeWhere((t) => t.id == task.id);
      // await NotificationService.cancelNotification(task.id);
      notifyListeners();
    }
  }
}