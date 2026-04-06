import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import '../screens/login_screen.dart';

class CafeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final bool showProfile;

  const CafeAppBar({
    super.key,
    this.profileImageUrl,
    this.showProfile = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainer,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.coffee, color: AppColors.primary, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Easy Cafe',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              if (showProfile)
                PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: AppColors.surfaceContainerLowest,
                  onSelected: (value) {
                    debugPrint('CafeAppBar: PopupMenu selection: $value');
                    if (value == 'logout') {
                      debugPrint('CafeAppBar: Starting logout process...');
                      
                      // 1. Immediate visual confirmation
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logging out...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                      // 2. Perform sign out in background
                      Supabase.instance.client.auth.signOut().then((_) {
                        debugPrint('CafeAppBar: Supabase signOut complete');
                      }).catchError((e) {
                        debugPrint('CafeAppBar: Supabase signOut ERROR: $e');
                      });

                      // 3. Immediate navigation through the root navigator
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    } else if (value == 'profile') {
                      // Navigate to profile
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text('My Profile', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: AppColors.error, size: 20),
                          const SizedBox(width: 12),
                          Text('Logout', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerHighest,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: profileImageUrl != null
                          ? Image.network(
                              profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 20,
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
