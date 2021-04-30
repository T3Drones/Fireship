import 'package:fireship/shared/bottom_nav.dart';
import 'package:flutter/material.dart';

class TopicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('topics'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('topics...'),
      ),
      bottomNavigationBar: AppBottomNav(),
    );
  }
}
