import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final String? title;
  const TestPage({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text(title ?? 'Test Page'),
      ),
    );
  }
}
