import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  static const name = 'RegisterScreen';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();  // Cambiado de nameController a usernameController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,  // Usamos usernameController
              decoration: const InputDecoration(
                labelText: 'Username',  // Cambiado de 'Name' a 'Username'
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final String username = usernameController.text.trim();  // Usamos username en lugar de name
                final String email = emailController.text.trim();
                final String password = passwordController.text.trim();

                if (username.isEmpty || email.isEmpty || password.isEmpty) {
                  showSnackBar('All fields are required', context);
                  return;
                }

                try {
                  // Agregar usuario a Firestore con el username
                  await FirebaseFirestore.instance.collection('users').add({
                    'username': username,  // Almacenamos el username en Firestore
                    'email': email,
                    'password': password,  // Recuerda que deberías cifrar la contraseña en un caso real
                  });

                  showSnackBar('Registration successful', context);
                  context.pop(); // Navegar de vuelta a la pantalla de login
                } catch (e) {
                  showSnackBar(e.toString(), context);
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
