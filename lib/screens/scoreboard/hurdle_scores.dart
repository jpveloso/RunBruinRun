import 'package:flutter/material.dart';
import '../../styles/colours.dart';
import '../../styles/button_styles.dart';
import '../../styles/colours.dart';

class HurdleScoresPage extends StatelessWidget {
  final int highScore;

  HurdleScoresPage({required this.highScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hurdle Scores'),
      ),
      body: Center(
        child: Text('High Score: $highScore'),
      ),
    );
  }
}