import 'dart:async';

import 'package:auth_supabase_flutter/screens/dashboard_screen.dart';
import 'package:auth_supabase_flutter/screens/login_screen.dart';
import 'package:auth_supabase_flutter/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  late StreamSubscription<AuthState> subscription;

  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async {
    setState(() {
      // obtener el usuario actual de Supabase
      _user = SupabaseService().currentUser();
    });

    // escucha los cambios que hay en la autenticación en:
    //signedIn, signedOut, tokenRefreshed, passwordRecovery, userUpdated
    subscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _user = data.session?.user;
      });
    });
  }

  @override
  void dispose() {
    // Cancelar la suscripción cuando no se necesite
    // (evitar memory leaks) fugas de memoria
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación con Supabase'),
        centerTitle: true,
      ),
      body: _user == null ? const LoginScreen() : const DashboardScreen(),
    );
  }
}
