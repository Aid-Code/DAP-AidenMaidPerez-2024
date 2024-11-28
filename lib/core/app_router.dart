import 'package:firebase_test/entities/kit.dart';
import 'package:firebase_test/screens/details_screen.dart';
import 'package:firebase_test/screens/home_screen.dart';
import 'package:firebase_test/screens/login_screen.dart';
import 'package:firebase_test/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    name: LoginScreen.name,
    path: '/',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    name: RegisterScreen.name,
    path: '/register',
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    name: HomeScreen.name,
    path: '/home',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    name: DetailsScreen.name,
    path: '/home/details/:kit',
    builder: (context, state) => DetailsScreen(kit: state.extra as Kit),
  ),
]);
