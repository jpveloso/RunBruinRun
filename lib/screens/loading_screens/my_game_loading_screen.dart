import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/hurdle/game.dart';

import 'loading_screen.dart';

class GameLoadingScreen extends StatefulWidget {
  const GameLoadingScreen({Key? key}) : super(key: key);

  @override
  GameLoadingScreenState createState() => GameLoadingScreenState();
}

class GameLoadingScreenState extends State<GameLoadingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssets();
    });
  }

  void _loadAssets() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: _isLoading ? const LoadingScreen() : const MyGame(),
    );
  }
}
