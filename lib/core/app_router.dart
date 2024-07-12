import 'package:app_idx/entities/kit.dart';
import 'package:app_idx/screens/details_screen.dart';
import 'package:app_idx/screens/home_screen.dart';
import 'package:app_idx/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    name: LoginScreen.name,
    path: '/',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    name: HomeScreen.name,
    path: '/home',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    name: DetailsScreen.name,
    path: '/home/details/:kit',
    builder: (context, state) => DetailsScreen(kit: state.extra as Kit),
  ),
]);
