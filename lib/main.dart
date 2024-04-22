import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:message_bottle/screen/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  await Supabase.initialize(
    url: supabaseUrl.toString(),
    anonKey: supabaseAnonKey.toString(),
  );

  runApp(
    // const MyApp()
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}