import 'package:flutter/material.dart';

class TesterHelperWidget extends StatelessWidget {
  const TesterHelperWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}
