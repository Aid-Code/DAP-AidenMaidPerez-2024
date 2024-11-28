import 'package:firebase_test/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isButtonEnabled = false;
  bool isUsernameValid = true;
  bool isPasswordValid = true;

  String? generalError; // Para mostrar un error general en la pantalla

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  Future<void> _loginUser() async {
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;

    try {
      final userManager = Provider.of<UserProvider>(context, listen: false);

      // Llamada al método login
      final authenticated = await userManager.login(enteredEmail, enteredPassword);

      if (authenticated) {
        final currentUser = userManager.currentUser;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Bienvenido ${currentUser?.username}!')),
        );

        context.push('/home'); // Redirigir a la pantalla principal
      } else {
        setState(() {
          isUsernameValid = false;
          isPasswordValid = false;
          generalError = userManager.errorMessage; // Mostrar el error específico
        });

        print('Error de autenticación: ${userManager.errorMessage}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userManager.errorMessage)),
        );
      }
    } catch (e) {
      setState(() {
        generalError = 'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.';
      });

      print('Error inesperado durante el login: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error inesperado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Iniciar sesión',
              style: TextStyle(fontFamily: 'InknutAntiqua', fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Mostrar un error general si ocurre
            if (generalError != null)
              Text(
                generalError!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: isUsernameValid ? null : 'Email no encontrado',
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                errorText: isPasswordValid ? null : 'Contraseña incorrecta',
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isButtonEnabled ? _loginUser : null,
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.push('/register'); // Redirigir a registro
              },
              child: const Text('¿No tienes una cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
