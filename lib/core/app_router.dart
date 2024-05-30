import 'package:app_idx/screens/arduinouno_screen.dart';
import 'package:app_idx/screens/home_screen.dart';
import 'package:app_idx/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter
(
  routes: 
  [
    GoRoute
    (
      name: LoginScreen.name,
      path: '/',
      builder:(context, state) => LoginScreen(), 
    ),

    GoRoute
    (
      name: HomeScreen.name,
      path: '/home',
      builder:(context, state) => HomeScreen( userName: state.extra as String,), 
    ),

    GoRoute
    (
      name: ArduinoUno.name,
      path: '/home/arduinoUno',
      builder:(context, state) => ArduinoUno(), 
    ),
  ]
);