import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.blue,
        toolbarHeight: 48,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4,
        color: Colors.blue,
        child: SizedBox(height: 48),
      ),
    );
  }
}
