// ignore_for_file: use_build_context_synchronously

import 'package:auth_supabase_flutter/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginScreen> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // validar los campos del formulario
    if (_formKey.currentState!.validate()) {
      try {
        // servicio para iniciar sesión con email en Supabase
        await SupabaseService().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on AuthException catch (error) {
        showMessage(
          context,
          error.message,
          Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Iniciar Sesión'),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });
                          try {
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            // servicio para registrarse con email en Supabase
                            final userResponse =
                                await SupabaseService().signUpWithEmail(
                              email: email,
                              password: password,
                            );

                            if (userResponse != null) {
                              showMessage(
                                context,
                                'El correo ya se encuentra creado. Ahora puede iniciar sesión!',
                                Colors.green,
                              );
                            }

                            setState(() {
                              _loading = false;
                            });
                          } on AuthException catch (error) {
                            showMessage(
                              context,
                              error.message,
                              Colors.red,
                            );
                          }
                        },
                        child: const Text('Registrarse'),
                      ),
                    ]))
              ],
            ),
          );
  }

  void showMessage(BuildContext context, String message, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
    setState(() {
      _loading = false;
    });
  }
}
