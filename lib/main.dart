import 'package:auth_supabase_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // credenciales de Supabase
  await Supabase.initialize(url: 'SUPABASE_URL', anonKey: 'SUPABASE_ANON_KEY');
  runApp(const HomeWidget());
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.greenAccent),
      home: HomeScreen(),
    );
  }
}
