import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_test/providers/user_provider.dart'; // Asegúrate de importar UserManager

class RegisterScreen extends StatefulWidget {
  static const name = 'RegisterScreen';

  const RegisterScreen({super.key});

  @override
  _RegisterScreentate createState() => _RegisterScreentate();
}

class _RegisterScreentate extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isButtonEnabled = false; // Estado del botón para habilitarlo solo cuando los campos no están vacíos
  bool _isUsernameValid = true; // Estado del campo del username
  bool _isPasswordValid = true; // Estado del campo de contraseña
  bool _isEmailValid = true; // Estado del campo de email

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Función para habilitar el botón de registro solo si los campos no están vacíos
  void _validateForm() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _usernameController.text.isNotEmpty;
    });
  }

  Future<void> _registerUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;

    try {
      final userManager = Provider.of<UserProvider>(context, listen: false);
      bool registrationSuccess = await userManager.register(username, email, password);

      if (registrationSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Usuario registrado con éxito!')),
        );
        context.push("/"); // Regresar a la pantalla anterior
      } else {
        setState(() {
          _isUsernameValid = true;
          _isPasswordValid = true;
          _isEmailValid = true;
        });

        // Si no fue exitoso, se muestra el error del UserManager
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userManager.errorMessage)),
        );
      }
    } catch (e) {
      // En caso de un error inesperado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error inesperado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar usuario'),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.pop();  // Usar context.pop() si estás usando go_router
        },
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Regístrate',
              style: TextStyle(fontFamily: 'InknutAntiqua', fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: _isUsernameValid ? null : 'Username inválido',
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _isEmailValid ? null : 'Email inválido o ya registrado',
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                errorText: _isPasswordValid ? null : 'Contraseña inválida',
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _registerUser : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled
                    ? const Color.fromARGB(255, 0, 55, 118)
                    : Colors.grey,
              ),
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.pop(); // Regresar a la pantalla anterior
              },
              child: const Text('¿Ya tienes una cuenta? Inicia sesión aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
