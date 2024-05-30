import 'package:app_idx/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  static const name = 'LoginScreen';
  LoginScreen({super.key});

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  List<String> errorMessages = 
  [ 
    'Incorrect username', 
    'Incorrect password',
    'Incorrect username and password'
    'Username and password are required',
    'Username is required',
    'Password is required'
  ];

  List<Map<String, String>> usersAndPasswords = 
  [
    {
      'username': 'Aid', 
      'password': '123'
    },

    {
      'username': 'Ale', 
      'password': 'soyAle'
    },

    {
      'username': 'Marcos', 
      'password': 'miContraseña123'
    }
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
              onPressed: () 
              {
                String inputUser = userController.text;
                String inputPass = passController.text;

                if (inputPass.isNotEmpty && inputUser.isNotEmpty) 
                {
                  bool userFound = false;
                  bool passFound = false;

                  for (var user in usersAndPasswords) 
                  {
                    if (user['username'] == inputUser) 
                    {
                      userFound = true;
                      if (userFound && user['password'] == inputPass)
                      {
                        passFound = true;
                        context.pushNamed(HomeScreen.name, extra: userController.text);
                        break;
                      }
                    }
                  }
                  if (!userFound && !passFound) 
                  {
                    showSnackBar(errorMessages[2], context);
                  }
                  else if (!userFound)
                  {
                    showSnackBar(errorMessages[0], context);
                  }
                  else if (!passFound)
                  {
                    showSnackBar(errorMessages[1], context);
                  }
                } 
                else if (inputUser.isEmpty) 
                {
                  showSnackBar(errorMessages[3], context);
                } 
                else if (inputUser.isEmpty) 
                {
                  showSnackBar(errorMessages[4], context);
                }
                else if (inputPass.isEmpty) 
                {
                  showSnackBar(errorMessages[5], context);
                }

              },
              child: const Text
              (
                'Login',
              )
            )
          ],
        ),
      )
    );
  }
}

void showSnackBar(String message, BuildContext context)
{
  String errorMessage = message;
  SnackBar snackErrors = SnackBar
  (
    content: Text(errorMessage)
  );

  ScaffoldMessenger.of(context).showSnackBar(snackErrors);
}
