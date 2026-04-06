import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  // Absolute minimum startup to ensure Flutter engine can initialize surface
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env variables
  await dotenv.load(fileName: ".env");
  
  // ROOT INITIALIZATION: InitializationWrapper MUST be the parent of the entire app
  // This ensures its initState runs before MaterialApp pumps its first frame.
  runApp(
    const InitializationWrapper(
      child: EasyCafeApp(),
    ),
  );
}

class EasyCafeApp extends StatelessWidget {
  const EasyCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Cafe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}

class InitializationWrapper extends StatefulWidget {
  final Widget child;
  const InitializationWrapper({super.key, required this.child});

  static _InitializationWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<_InitializationWrapperState>();
  }

  @override
  State<InitializationWrapper> createState() => _InitializationWrapperState();
}

class _InitializationWrapperState extends State<InitializationWrapper> {
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _performInitialization();
  }

  Future<void> _performInitialization() async {
    // 1. HARD BLOCK: Force hide keyboard IMMEDIATELY to stop the metric storm
    try {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (_) {}

    // 2. STABILIZE FONTS: Re-enable fetching in a controlled manner
    GoogleFonts.config.allowRuntimeFetching = true;

    // 3. INIT SUPABASE: Perform heavy async work after the first frame is pumped
    try {
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? '',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      );
    } catch (e) {
      debugPrint('Supabase Initialization Warning: $e');
    }

    if (mounted) {
      setState(() => isInitialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
