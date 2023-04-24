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

class WidgetWithMetadata<T> extends StatelessWidget {
  const WidgetWithMetadata({
    super.key,
    required this.metadata,
    required this.child,
  });

  final T metadata;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
