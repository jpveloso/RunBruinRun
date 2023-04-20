import 'package:flutter/material.dart';
import '../../styles/colours.dart';
import '../../styles/button_styles.dart';
import '../hurdle/game.dart';

class HurdleScoresPage extends StatelessWidget {
  final int? highScore;

  const HurdleScoresPage({Key? key, this.highScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hurdle Scores'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'High Score: ${highScore ?? "N/A"}',
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyGame()),
                );
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
