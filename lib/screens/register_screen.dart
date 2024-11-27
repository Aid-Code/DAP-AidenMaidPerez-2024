import 'package:app_idx/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Importar Provider

class RegisterScreen extends StatelessWidget {
  static const name = 'RegisterScreen';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();  // Cambiado de nameController a usernameController

  @override
  Widget build(BuildContext context) {
    // Acceder al AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);

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
            authProvider.isLoading
                ? const CircularProgressIndicator() // Indicador de carga mientras se registra
                : ElevatedButton(
                    onPressed: () async {
                      final String username = usernameController.text.trim();  // Usamos username
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();

                      if (username.isEmpty || email.isEmpty || password.isEmpty) {
                        showSnackBar('All fields are required', context);
                        return;
                      }

                      // Llamar al método de registro en el AuthProvider
                      bool success = await authProvider.register(username, email, password);

                      if (success) {
                        showSnackBar('Registration successful', context);
                        context.pop(); // Volver a la pantalla de login
                      } else {
                        showSnackBar(authProvider.errorMessage, context); // Mostrar error de registro
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
