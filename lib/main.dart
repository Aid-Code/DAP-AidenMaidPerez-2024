import 'package:firebase_test/core/app_router.dart';
import 'package:firebase_test/providers/kit_provider.dart';
import 'package:firebase_test/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Puedes añadir aquí más providers si es necesario
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => KitProvider()) // Proveedor de autenticación
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        theme: ThemeData.dark(),
      ),
    );
  }
}


