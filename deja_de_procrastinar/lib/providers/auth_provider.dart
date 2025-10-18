// lib/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart'; // RUTA CORREGIDA: 'repositories'

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user; // El usuario actual logueado

  User? get user => _user;

  AuthProvider(this._authRepository) {
    // Esto comprueba si hay un usuario logueado al iniciar la app
    _user = _authRepository.getCurrentUser();
    notifyListeners();
  }

  // Método que llama al repositorio e inicia sesión
  Future<void> signIn(String email, String password) async {
    // Si el repositorio lanza una excepción (ej: contraseña incorrecta),
    // esta pasará directamente a la pantalla de login para ser manejada allí.
    _user = await _authRepository.signIn(email: email, password: password);

    notifyListeners(); // Notifica a la UI si el login fue exitoso
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null; // Limpiamos el usuario
    notifyListeners();
  }
}
