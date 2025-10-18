// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones para Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Importaciones de Providers y Repositorios
import 'providers/tareas_provider.dart';
import 'providers/auth_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/tareas_repository.dart'; // ¡Necesario para inyectar!

import 'screens/login_screen.dart';
import 'screens/tareas_screen.dart';

// Hacemos main async para inicializar Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        // 1. AuthProvider: Provee el estado de autenticación (User?)
        ChangeNotifierProvider(
          create: (context) => AuthProvider(AuthRepository()),
        ),

        // 2. TareasProvider: Depende del estado de AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, TareasProvider?>(
          create: (context) => null,
          update: (context, authProvider, previous) {
            final userId = authProvider.user?.uid;

            // Crea TareasProvider solo si hay un usuario logueado
            if (userId != null) {
              // Llamada al constructor CON ARGUMENTOS NOMBRADOS
              return TareasProvider(
                userId: userId,
                tareasRepository: TareasRepository(),
              );
            }
            // Si NO hay usuario, devuelve null.
            return null;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color colorPrincipal = Colors.teal;

    return MaterialApp(
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
      // RF6: Navegación condicional basada en el estado de autenticación.
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Si el usuario NO es nulo, navega a TareasScreen
          if (authProvider.user != null) {
            return const TareasScreen();
          }
          // Si el usuario es nulo, se queda en LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}
