import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/search/search_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint("Failed to load .env file: $e");
  }

  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? 'https://placeholder.supabase.co',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder_key',
    );
  } catch (e) {
    debugPrint("Failed to initialize Supabase: $e");
  }
  
  runApp(const ProviderScope(child: LettingExpertsApp()));
}

class LettingExpertsApp extends StatelessWidget {
  const LettingExpertsApp({super.key});
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (ctx, st) => const SearchPage()),
      ],
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Letting Experts',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFCE3132), // Letting Red
        scaffoldBackgroundColor: const Color(0xFF2C2C2C), // Medium Grey
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C1C1C), // Expert Black
          elevation: 0,
        ),
      ),
      routerConfig: router,
    );
  }
}
