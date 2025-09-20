
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/auth_provider.dart';

import '../components/textformfieldEx.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: "username")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            RoundedText(controller: passCtrl, obscureText: true,labelText: "Password"),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() => loading = true);
                final success = await auth.register(usernameCtrl.text, emailCtrl.text, passCtrl.text);
                setState(() => loading = false);
                if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Register failed")));
                } else {
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
