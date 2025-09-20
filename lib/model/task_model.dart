// class Task {
//   final int id;
//   final String title;
//    bool completed;
//   final int? userId;
//
//
//   Task({required this.id, required this.title, this.completed = false, this.userId});
//
//   factory Task.fromJson(Map<String, dynamic> json) => Task(
//     id: json['id'],
//     title: json['title'],
//     completed: json['completed'] ?? false,
//     userId: json['userId'],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "title": title,
//     "completed": completed,
//     "userId": userId,
//   };
// }
//


// lib/models/task_model.dart
import 'dart:convert';

class Task {
  final int id; // use API id if available, otherwise local generated id
  final int userId; // API user id
  final String title;
   bool completed;

  // Local-only / extended
  final String? description;
  final DateTime? dueDate;
  final String priority; // High/Medium/Low
  final String status;   // To-Do/In Progress/Done
  final int? assignedUserId;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.completed = false,
    this.description,
    this.dueDate,
    this.priority = "Medium",
    this.status = "To-Do",
    this.assignedUserId,
  });

  // API JSON (minimal)
  factory Task.fromApiJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toApiJson() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "completed": completed,
    };
  }

  // Local DB JSON (full)
  factory Task.fromDb(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'] == 1,
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: json['priority'] ?? "Medium",
      status: json['status'] ?? "To-Do",
      assignedUserId: json['assignedUserId'],
    );
  }

  Map<String, dynamic> toDb() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "completed": completed ? 1 : 0,
      "description": description,
      "dueDate": dueDate?.toIso8601String(),
      "priority": priority,
      "status": status,
      "assignedUserId": assignedUserId,
    };
  }

  String toRawJson() => jsonEncode(toDb());
  factory Task.fromRawJson(String str) => Task.fromDb(jsonDecode(str));
}
