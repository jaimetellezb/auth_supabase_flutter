import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Métodos de autenticación
  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      if (e.code == 'user_already_exists') {
        throw AuthException('El correo ya está registrado');
      } else {
        throw AuthException('Error en el login:: ${e.message}');
      }
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? currentUser() {
    return _client.auth.currentUser;
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      if (e.code == 'user_already_exists') {
        throw AuthException('El correo ya está registrado');
      } else {
        throw AuthException('Error de registro: ${e.message}');
      }
    }
  }
}
