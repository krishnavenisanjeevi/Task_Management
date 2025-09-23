import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/screens/register_screen.dart';
import 'package:task_management/screens/tasklist_screen.dart';

import '../components/textformfieldEx.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
              RoundedText(controller: passCtrl, obscureText: true, labelText: "Password"),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  setState(() => loading = true);
                  final success = await auth.login(emailCtrl.text, passCtrl.text);
                  setState(() => loading = false);

                  if(success) {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (_) => const TaskListScreen()),
                   );
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("LogIn successfully")));
                  }
                  if (!success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login failed")));
                  }
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text("No account? Register here"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
