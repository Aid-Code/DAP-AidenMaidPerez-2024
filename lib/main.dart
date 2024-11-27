import 'package:app_idx/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa el paquete provider
import 'providers/auth_provider.dart'; // Importa el AuthProvider (o el provider que estés utilizando)

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Puedes añadir aquí más providers si es necesario
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Proveedor de autenticación
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        theme: ThemeData.dark(),
      ),
    );
  }
}
