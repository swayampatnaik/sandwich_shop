import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'common_widgets.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showCartAction;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.leading,
    this.actions,
    this.showCartAction = true,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool wide = width >= 800;

    // For wide screens show a persistent side navigation, otherwise a Drawer
    final PreferredSizeWidget appBar = buildCommonAppBar(
      context: context,
      title: title,
      leading: wide ? leading : null,
      actions: actions,
      showCartAction: showCartAction,
    );

    if (wide) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            const SizedBox(
              width: 240,
              child: Material(
                elevation: 2,
                child: Column(
                  children: [
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
      appBar: appBar,
      drawer: const AppDrawer(),
      body: body,
    );
  }
}