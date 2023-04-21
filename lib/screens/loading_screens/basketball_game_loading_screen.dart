import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/basketball/basketBallGameScreen.dart';

import 'loading_screen.dart';

class BasketBallGameLoadingScreen extends StatefulWidget {
  const BasketBallGameLoadingScreen({Key? key}) : super(key: key);

  @override
  BasketBallGameLoadingScreenState createState() => BasketBallGameLoadingScreenState();
}

class BasketBallGameLoadingScreenState extends State<BasketBallGameLoadingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _loadAssets();
    // });
    _loadAssets();
  }

  void _loadAssets() async {
    // Load game assets here
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: _isLoading
          ? const LoadingScreen()
          : const BasketballGameScreen(),
    );
  }
}