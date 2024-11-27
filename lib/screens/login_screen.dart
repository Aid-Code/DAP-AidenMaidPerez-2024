import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              isLoading
                  ? const CircularProgressIndicator() // Show loading indicator while processing
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

                        setState(() {
                          isLoading = true; // Start loading
                        });

                        try {
                          // Buscar usuario en Firestore
                          QuerySnapshot userQuery = await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: email)
                              .where('password', isEqualTo: password)
                              .get();

                          if (userQuery.docs.isNotEmpty) {
                            // Usuario encontrado, navegar a la pantalla de inicio
                            context.pushNamed(HomeScreen.name);
                          } else {
                            showSnackBar('User not found or incorrect password', context);
                          }
                        } catch (e) {
                          showSnackBar('An unexpected error occurred: $e', context);
                        } finally {
                          setState(() {
                            isLoading = false; // Stop loading
                          });
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
}

void showSnackBar(String message, BuildContext context) {
  SnackBar snackErrors = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackErrors);
}
