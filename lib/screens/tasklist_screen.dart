import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/notification_service.dart';
import '../provider/task_provider.dart';
import '../provider/user_provider.dart';
import 'addtask_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
      Provider.of<UserProvider>(context, listen: false).fetchUser(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<TaskProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final userProv = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager"),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
             auth.logout();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logout Successfully")));
            },
        ),
        IconButton(
          icon: const Icon(Icons.alarm),
          onPressed: () {
            NotificationService.showInstantNotification(id: 1, body: "alarm",title: "notification");
            // NotificationService.scheduleNotification(
            //   1, "hello"," notification",
            //   // task.id,
            //   // task.title,
            //   // "Reminder: ${task.description}",
            //   // task.dueDate!,
            // );
          },
        )

      ],
    ),
      body: Scaffold(
        body: Column(
          children: [
            if (userProv.user != null)
              ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(userProv.user!.avatar)),
                title: Text("${userProv.user!.firstName} ${userProv.user!.lastName}"),
                subtitle: Text(userProv.user!.email),
              ),
            Expanded(
              child: taskProv.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: taskProv.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProv.tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: ListTile(
                      onTap: (){
                        AddTaskScreen(task: task);
                      },
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (v) {
                          task.completed = v ?? false;
                          taskProv.updateTask(task);
                        },
                      ),
                      title: Text(task.title),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => taskProv.deleteTask(task),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          },
        child: const Icon(Icons.add),
      ),
    );
  }

}