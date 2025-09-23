import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/auth_provider.dart';
import 'package:task_management/provider/category_provider.dart';
import 'package:task_management/provider/notification_service.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/provider/user_provider.dart';
import 'package:task_management/screens/tasklist_screen.dart';
import 'package:task_management/additional/user_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(),
     ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
      // const TaskListScreen()
      Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.initialized) {
            return const SplashScreen(); // still checking
          }
        return auth.isLoggedIn ? const TaskListScreen() : const LoginScreen();
         }
      ),
    );
  }
}



// NotificationService.scheduleNotification(
// task.id,
// task.title,
// "Reminder: ${task.description}",
// task.dueDate!,
// );
