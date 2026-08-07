import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_shell/app_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseVault',
      debugShowCheckedModeBanner: false,
      theme: buildExpressiveLightTheme(),
      darkTheme: buildExpressiveDarkTheme(),
      home: const AppShell(),
      themeMode: ThemeMode.system,
    );
  }
}
