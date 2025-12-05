import 'package:flutter/material.dart';
import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? leading;

  const AppScaffold({super.key, required this.title, required this.body, this.leading});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool wide = width >= 800;

    // For wide screens show a persistent side navigation, otherwise a Drawer
    if (wide) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: leading,
        ),
        body: Row(
          children: [
            const SizedBox(
              width: 240,
              child: Material(
                elevation: 2,
                child: Column(
                  children: [
                    // Reuse drawer content inside a container
                    Expanded(child: AppDrawer()),
                  ],
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    // Narrow screens: provide standard drawer
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: leading,
      ),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}