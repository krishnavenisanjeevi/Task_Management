import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'api_service.dart';


class TaskFormScreen extends StatefulWidget {
  final Map<String, dynamic>? task; // if null → create, else edit

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  DateTime? _dueDate;
  String _priority = "Medium";
  String _status = "To-Do";
  int? _assignedUserId;

  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();

    // If editing, populate fields
    if (widget.task != null) {
      _titleCtrl.text = widget.task!["title"] ?? "";
      _descCtrl.text = widget.task!["description"] ?? "";
      _priority = widget.task!["priority"] ?? "Medium";
      _status = widget.task!["status"] ?? "To-Do";
      if (widget.task!["dueDate"] != null) {
        _dueDate = DateTime.tryParse(widget.task!["dueDate"]);
      }
      _assignedUserId = widget.task!["assignedUserId"];
    }
  }

 _loadUsers() async {
    final user = await ApiService.getUser(2); // returns List<dynamic>
    setState(() => _users.add(user));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _dueDate ?? DateTime.now(),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final newTask = {
      "title": _titleCtrl.text,
      "description": _descCtrl.text,
      "dueDate": _dueDate?.toIso8601String(),
      "priority": _priority,
      "status": _status,
      "assignedUserId": _assignedUserId,
    };

    if (widget.task == null) {
      // Create
      // print("Create Task: $newTask");
      ApiService.createTask(_titleCtrl.text);
    } else {
      // Update
      print("update tasks");
     // ApiService.updateTask()
    }

    Navigator.pop(context, newTask); // return newTask to caller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Create Task" : "Edit Task"),
      ),
      body: _users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Due Date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? "No due date selected"
                          : "Due: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}",
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Pick Date"),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _priority,
                items: ["High", "Medium", "Low"]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _priority = val!),
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _status,
                items: ["To-Do", "In Progress", "Done"]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Assigned User Dropdown
              DropdownButtonFormField<int>(
                value: _users.first["first_name"],
                hint: const Text("Assign to User"),
                items: _users
                    .map((u) => DropdownMenuItem<int>(
                  value: u["id"],
                  child: Text("${u["first_name"]} ${u["last_name"]}"),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _assignedUserId = val),
                decoration: const InputDecoration(
                  labelText: "Assigned User",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text("Save Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
