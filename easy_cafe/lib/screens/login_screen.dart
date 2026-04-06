import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import 'admin_shell.dart';
import 'user_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _canRequestFocus = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final emailRaw = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      // Auto-append @easycafe.com if user types just 'superadmin' etc
      final email = emailRaw.contains('@') ? emailRaw : '$emailRaw@easycafe.com';

      try {
        final supabase = Supabase.instance.client;
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user != null && mounted) {
           final userMeta = response.user!.userMetadata;
           final role = userMeta?['role'] ?? 'user';
           
           if (role == 'admin') {
             Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => const AdminShell()),
             );
           } else {
             Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => const UserShell()),
             );
           }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid credentials or network error.',
                style: GoogleFonts.inter(color: AppColors.onError),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Prevent focus for the first few seconds to stabilize the Engine layout
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _canRequestFocus = true);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Title Header
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.outline.withOpacity(0.2)),
                    ),
                    child: const Icon(Icons.coffee, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Easy Cafe',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'THE TACTILE ATELIER PORTAL',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Login Form Container
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.outline.withOpacity(0.1)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Email Address',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            onChanged: (_) {
                              if (!_canRequestFocus) _emailFocus.unfocus();
                            },
                            onTap: () {
                              if (!_canRequestFocus) _emailFocus.unfocus();
                            },
                            style: const TextStyle(color: AppColors.onSurface),
                            decoration: const InputDecoration(
                              hintText: 'name@easycafe.com',
                            ),
                            validator: (value) => value!.isEmpty ? 'Enter email' : null,
                          ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Password',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Forgot Password?',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            onTap: () {
                              if (!_canRequestFocus) _passwordFocus.unfocus();
                            },
                            style: const TextStyle(color: AppColors.onSurface),
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: '••••••••',
                            ),
                            validator: (value) => value!.isEmpty ? 'Enter password' : null,
                          ),
                          const SizedBox(height: 32),

                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppColors.leatherGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Login', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          const Divider(color: AppColors.surfaceContainerHigh),
                          const SizedBox(height: 24),
                          
                          Text(
                            'New to the team?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Text(''), // Just want the trailing icon structure natively
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Request Staff Access',
                                    style: GoogleFonts.inter(
                                      color: AppColors.onSecondaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 16, color: AppColors.onSecondaryContainer),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
