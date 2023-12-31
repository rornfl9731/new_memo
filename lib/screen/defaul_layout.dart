import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final List<Widget>? icons;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DefaultLayout(
      {Key? key,
      required this.child,
      this.backgroundColor,
      this.title,
      this.bottomNavigationBar,
      this.icons,
      this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      floatingActionButton: floatingActionButton ?? null,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: icons,
      title: Text(
        title!,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      foregroundColor: Colors.black,
    );
  }
}
