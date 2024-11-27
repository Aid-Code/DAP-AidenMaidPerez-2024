import 'package:app_idx/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Importar Provider
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Acceder al AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Log in',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 50),
              authProvider.isLoading
                  ? const CircularProgressIndicator() // Mostrar el indicador de carga
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        String email = emailController.text.trim();
                        String password = passController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          showSnackBar('Email and password are required', context);
                          return;
                        }

                        // Llamar al método de login en el AuthProvider
                        bool success = await authProvider.login(email, password);

                        if (success) {
                          // Si el login es exitoso, navegar a la pantalla de inicio
                          context.pushNamed(HomeScreen.name);
                        } else {
                          // Si el login falla, mostrar el error
                          showSnackBar(authProvider.errorMessage, context);
                        }
                      },
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.pushNamed(RegisterScreen.name);
                },
                child: const Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String message, BuildContext context) {
    SnackBar snackErrors = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackErrors);
  }
}
