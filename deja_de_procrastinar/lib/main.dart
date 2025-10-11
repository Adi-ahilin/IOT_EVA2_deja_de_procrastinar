// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importa el paquete provider
import 'providers/tareas_provider.dart'; // 2. Importa tu nuevo provider
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color colorPrincipal = Colors.teal;

    // 3. Envuelve MaterialApp con ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (context) => TareasProvider(),
      child: MaterialApp(
        title: 'Deja de Procrastinar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: colorPrincipal,
          appBarTheme: const AppBarTheme(
            backgroundColor: colorPrincipal,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrincipal,
              foregroundColor: Colors.white,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: colorPrincipal),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
