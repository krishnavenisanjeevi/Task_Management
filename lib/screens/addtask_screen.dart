// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../model/task_model.dart';
// import '../provider/category_provider.dart';
// import '../provider/task_provider.dart';
// import 'package:intl/intl.dart';
//
// class AddTaskScreen extends StatefulWidget {
//    const AddTaskScreen({super.key, this.taskName, this.dueDate});
//   final String? taskName;
//   final DateTime? dueDate;
//
//   @override
//   State<AddTaskScreen> createState() => _AddTaskScreenState();
// }
//
// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final _titleController = TextEditingController();
//   DateTime? _selectedDate;
//
//   @override
//   Widget build(BuildContext context) {
//     final taskProv = Provider.of<TaskProvider>(context, listen: false);
//     taskProv.fetchTasks();
//     final categoryProv = Provider.of<CategoryProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Task")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Task Name
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(
//                 labelText: "Task Name",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Due Date
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     _selectedDate == null
//                         ? "No due date"
//                         :  "Due: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}",
//                   ),
//                 ),
//                 TextButton(
//                   child: const Text("Pick Date"),
//                   onPressed: () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2100),
//                       initialDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() => _selectedDate = picked);
//                     }
//                   },
//                 )
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Category Dropdown + Add New
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: categoryProv.selected,
//                     hint: const Text("Select Category"),
//                     items: categoryProv.categories
//                         .map((cat) =>
//                         DropdownMenuItem(value: cat, child: Text(cat)))
//                         .toList(),
//                     onChanged: (val) => categoryProv.selectCategory(val),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () => _showAddCategoryDialog(context),
//                 )
//               ],
//             ),
//             const Spacer(),
//
//             // Save Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_titleController.text.isNotEmpty) {
//                     taskProv.addTask(_titleController.text);
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text("Save Task"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showAddCategoryDialog(BuildContext context) {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("New List"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: "Enter list name"),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           TextButton(
//             onPressed: () {
//               if (controller.text.isNotEmpty) {
//                 Provider.of<CategoryProvider>(context, listen: false)
//                     .addCategory(controller.text);
//               }
//               Navigator.pop(context);
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       ),
//     );
//   }
// }


// lib/screens/task_form_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/model/user_model.dart';
import 'package:task_management/service/db_handler.dart';

import '../model/task_model.dart';
import '../provider/task_provider.dart';
import '../provider/user_provider.dart';


class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  DateTime? _dueDate;
  String _priority = 'Medium';
  String _status = 'To-Do';
  int? _assignedUserId;
  List<dynamic> _users = [];
  bool _loadingUsers = true;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleCtrl.text = widget.task!.title;
      _descCtrl.text = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
      _status = widget.task!.status;
      _assignedUserId = widget.task!.assignedUserId;
    }
    _loadUsers();
  }

 _loadUsers() async {
    try {
      final users = await  Provider.of<UserProvider>(context, listen: false).fetchAllUser();
      setState(() {
        _users = users as List;
        _loadingUsers = false;
      });
    } catch (e) {
      setState(() => _loadingUsers = false);
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    if (time == null) {
      setState(() => _dueDate = DateTime(date.year, date.month, date.day));
      return;
    }
    setState(() => _dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TaskProvider>(context, listen: false);
    final isEdit = widget.task != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loadingUsers
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(_dueDate == null ? 'No due date' : DateFormat('yyyy-MM-dd HH:mm').format(_dueDate!)),
                  ),
                  TextButton(onPressed: _pickDateTime, child: const Text('Pick Date')),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['High', 'Medium', 'Low'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _priority = v!),
                decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['To-Do', 'In Progress', 'Done'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _status = v!),
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                value: _assignedUserId,
                items: _users.map((u) {
                  final id = u['id'] as int;
                  final name = '${u['first_name']} ${u['last_name']}';
                  return DropdownMenuItem<int>(value: id, child: Text(name));
                }).toList(),
                onChanged: (v) => setState(() => _assignedUserId = v),
                decoration: const InputDecoration(labelText: 'Assigned User', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(isEdit ? 'Update Task' : 'Create Task'),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final id = widget.task?.id ?? DateTime.now().millisecondsSinceEpoch;
                    final userId = widget.task?.userId ?? (_assignedUserId ?? 0);
                    final newTask = Task(
                      id: id,
                      userId: userId,
                      title: _titleCtrl.text.trim(),
                      description: _descCtrl.text.trim(),
                      dueDate: _dueDate,
                      priority: _priority,
                      status: _status,
                      assignedUserId: _assignedUserId,
                    );

                    if (isEdit) {
                      await prov.updateTask(newTask);
                      await DBHelper.updateTask(newTask);
                    } else {
                      await prov.addTask(newTask);
                      await DBHelper.addTask(newTask);
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
