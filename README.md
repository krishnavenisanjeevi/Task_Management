# task_management

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Login
 Email :eve.holt@reqres.in
 Password :123456

# 📌 Task Management App (Flutter)

A Flutter-based **Task Management** app with API integration, local storage, and notifications.

---

## 🚀 Features

- 🔐 **User Authentication**
    - Register & Login using [ReqRes API](https://reqres.in/)

- ✅ **Task Management**
    - Create, View, Edit, and Delete tasks
    - Attributes:
        - Title
        - Description
        - Due Date
        - Priority (High, Medium, Low)
        - Status (To-Do, In Progress, Done)
        - Assigned User (from API)
    - Real-time syncing with [JSONPlaceholder API](https://jsonplaceholder.typicode.com/)

- 📂 **Local Storage**
    - Offline support using **SQLite**
    - Tasks cached and synced when online

- 🔔 **Reminders**
    - Local notifications for task due dates

- ⚡ **Performance**
    - Optimized state management using **Provider**

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Local Database**: SQLite (sqflite)

[//]: # (- **Notifications**: flutter_local_notifications)
- **APIs**:
    - Auth → ReqRes API
    - Tasks → JSON
