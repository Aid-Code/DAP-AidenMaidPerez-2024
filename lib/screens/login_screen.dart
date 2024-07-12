import 'package:app_idx/entities/user.dart';
import 'package:app_idx/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  static const name = 'LoginScreen';
  LoginScreen({super.key});

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  List<String> errorMessages = [
    'Incorrect username',
    'Incorrect password',
    'Incorrect username and password',
    'Username and password are required',
    'Username is required',
    'Password is required'
  ];

  List<User> usersAndPasswords = [
    User('Aid', '123'),
    User('Ale', 'soyAle'),
    User('Marcos', 'miContraseña')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Log in',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: userController,
            decoration: const InputDecoration(
                hintText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: passController,
            decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)))),
            obscureText: true,
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              onPressed: () {
                String inputUser = userController.text;
                String inputPass = passController.text;

                if (inputUser.isEmpty && inputPass.isEmpty) {
                  showSnackBar(errorMessages[3],
                      context); // Username and password are required
                } else if (inputUser.isEmpty) {
                  showSnackBar(
                      errorMessages[4], context); // Username is required
                } else if (inputPass.isEmpty) {
                  showSnackBar(
                      errorMessages[5], context); // Password is required
                } else {
                  bool credentialsValid = false;

                  for (var user in usersAndPasswords) {
                    if (user.validateUser(inputUser, inputPass)) {
                      credentialsValid = true;
                      break;
                    }
                  }

                  if (credentialsValid) {
                    context.pushNamed(HomeScreen.name);
                  } else {
                    showSnackBar(errorMessages[2], context);
                  }
                }
              },
              child: const Text(
                'Login',
              )),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    ));
  }
}

void showSnackBar(String message, BuildContext context) {
  String errorMessage = message;
  SnackBar snackErrors = SnackBar(content: Text(errorMessage));

  ScaffoldMessenger.of(context).showSnackBar(snackErrors);
}
