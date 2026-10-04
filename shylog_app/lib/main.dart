import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/bindings/initial_binding.dart';
import 'modules/navigation/views/main_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShylogApp());
}

class ShylogApp extends StatelessWidget {
  const ShylogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Shylog — Boys' Fashion Store",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialBinding: InitialBinding(),
      home: const MainNavigationShell(),
    );
  }
}
