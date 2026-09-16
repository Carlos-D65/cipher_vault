import 'package:flutter/material.dart';

import 'router/app_router.dart';
import '../core/theme/app_theme.dart';

class CipherVaultApp extends StatelessWidget {
  const CipherVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CipherVault',
      theme: AppTheme.dark,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}