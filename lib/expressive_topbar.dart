import 'package:flutter/material.dart';

class ExpressiveTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ExpressiveTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 4,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
