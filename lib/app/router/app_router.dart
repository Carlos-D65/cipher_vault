import 'package:flutter/material.dart';
import '../../features/encryption/encrryption_dependencies.dart';
import '../../features/encryption/presentation/screens/protect_screen.dart';
import '../../features/steganography/steganography_dependencies.dart';
import '../../features/steganography/presentation/screens/hide_screen.dart';
import '../../features/decryption/decryption_dependencies.dart';
import '../../features/decryption/presentation/screens/decrypt_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String protect = '/protect';
  static const String decrypt = '/decrypt';
  static const String hide = '/hide';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    
    switch (settings.name) {

      case AppRouter.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen()
        );

      case protect:
      final controller = EncryptionDependencies.createProtectController();
        return MaterialPageRoute(
          builder: (_) => ProtectScreen(
            controller: controller,
          ),
        );

      case AppRouter.decrypt:
        final controller = DecryptionDependencies.createDecryptController();
        return MaterialPageRoute(
          builder: (_) => DecryptScreen(
            controller: controller,
          ),
        );

      case AppRouter.hide:
      final payload = settings.arguments is String
        ? settings.arguments as String
        : null;

        final controller = SteganographyDependencies.createHideController(
          initialPayload: payload,
        );
        return MaterialPageRoute(
          builder: (_) => HideScreen(
            controller: controller,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(
            title: 'Página no encontrada',
          ),
        );
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}