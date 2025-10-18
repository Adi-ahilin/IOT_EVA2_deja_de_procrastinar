// lib/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  // Instancia privada de Firebase Auth
  final FirebaseAuth _firebaseAuth;

  // Constructor para inyectar la dependencia (buena práctica)
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // 1. Método para iniciar sesión
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Si es exitoso, devuelve el usuario (User)
      return userCredential.user;
    } on FirebaseAuthException {
      // CORRECCIÓN: Usamos 'rethrow;' para mantener la pila de llamadas
      rethrow;
    }
  }

  // 2. Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // 3. Método para saber si hay un usuario actualmente
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
