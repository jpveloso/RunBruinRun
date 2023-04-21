import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';
import 'package:run_bruin_run/services/score_service.dart';
import 'package:run_bruin_run/styles/colours.dart';

import '../../styles/button_styles.dart';
import '../loading_screens/my_game_loading_screen.dart';
import 'bruin.dart';
import 'cloud.dart';
import 'constants.dart';
import 'game_object.dart';
import 'ground.dart';
import 'hurdle.dart';

final _audioPlayer = AudioPlayer();

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return const MaterialApp(
      title: 'Flutter Bruin',
      debugShowCheckedModeBanner: false,
      home: Game(),
    );
  }
}

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  State<MyGame> createState() => _GameState();
}

class _GameState extends State<MyGame> with SingleTickerProviderStateMixin {
  late final GlobalKey<ScaffoldState> _gameScaffoldKey;
  late final GlobalKey<FormState> _gameFormKey;
  Bruin bruin = Bruin();
  bool _isGameOver = false;
  double runVelocity = initialVelocity;
  double runDistance = 0;
  int highScore = 0;
  TextEditingController gravityController =
      TextEditingController(text: gravity.toString());
  TextEditingController accelerationController =
      TextEditingController(text: acceleration.toString());
  TextEditingController jumpVelocityController =
      TextEditingController(text: jumpVelocity.toString());
  TextEditingController runVelocityController =
      TextEditingController(text: initialVelocity.toString());

  late AnimationController worldController;
  Duration lastUpdateCall = const Duration();

  List<Hurdle> hurdle = [Hurdle(worldLocation: const Offset(200, 0))];

  List<Ground> ground = [
    Ground(worldLocation: const Offset(0, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
  ];

  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  @override
  void initState() {
    super.initState();
    _gameScaffoldKey = GlobalKey<ScaffoldState>();
    _gameFormKey = GlobalKey<FormState>();
    highScore = 0;
    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));
    worldController.addListener(_update);
    worldController.stop();
    bruin.die();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tap to play!',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
          duration: Duration(milliseconds: 2000),
          backgroundColor: darkBruinBlue,
        ),
      );
    });
  }

  void onPlayAgain() {
    setState(() {
      _isGameOver = false;
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const GameLoadingScreen()));
  }

  void _die() {
    setState(() {
      highScore = max(highScore, runDistance.toInt());
      worldController.stop();
      bruin.die();
      Source gameOverSound = AssetSource('sounds/game_over_bad_chest.wav');
      _audioPlayer.play(gameOverSound);
      _isGameOver = true;
    });
    saveHighScore(highScore);
  }

  void _newGame() {
    setState(() {
      highScore = max(highScore, runDistance.toInt());
      runDistance = 0;
      runVelocity = initialVelocity;
      bruin.state = BruinState.running;
      bruin.dispY = 0;
      worldController.reset();
      hurdle = [
        Hurdle(worldLocation: const Offset(200, 0)),
        Hurdle(worldLocation: const Offset(300, 0)),
        Hurdle(worldLocation: const Offset(450, 0)),
      ];

      ground = [
        Ground(worldLocation: const Offset(0, 0)),
        Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
      ];

      clouds = [
        Cloud(worldLocation: const Offset(100, 20)),
        Cloud(worldLocation: const Offset(200, 10)),
        Cloud(worldLocation: const Offset(350, -15)),
        Cloud(worldLocation: const Offset(500, 10)),
        Cloud(worldLocation: const Offset(550, -10)),
      ];
      worldController.forward();
    });
  }

  _update() {
    try {
      double elapsedTimeSeconds;
      bruin.update(lastUpdateCall, worldController.lastElapsedDuration);
      try {
        elapsedTimeSeconds =
            (worldController.lastElapsedDuration! - lastUpdateCall)
                    .inMilliseconds /
                1000;
      } catch (_) {
        elapsedTimeSeconds = 0;
      }

      runDistance += runVelocity * elapsedTimeSeconds;
      if (runDistance < 0) runDistance = 0;

      final numHurdlesCleared = hurdle.length - 1; // Ignore first hurdle
      acceleration =
          baseAcceleration + numHurdlesCleared * accelerationIncrement;

      runVelocity += acceleration * elapsedTimeSeconds;

      Size screenSize = MediaQuery.of(context).size;

      Rect bruinRect = bruin.getRect(screenSize, runDistance);
      for (Hurdle hurdles in hurdle) {
        Rect obstacleRect = hurdles.getRect(screenSize, runDistance);
        if (bruinRect.overlaps(obstacleRect.deflate(20))) {
          _die();
        }
        if (obstacleRect.right < 0) {
          setState(() {
            // Calculate distance to last hurdle added
            double lastHurdlePos = hurdle.last.worldLocation.dx;
            double newHurdlePos = runDistance +
                Random().nextInt(200) +
                screenSize.width / worlToPixelRatio;
            double distToLastHurdle = newHurdlePos - lastHurdlePos;

            // Choose new position for hurdle if too close to last hurdle
            if (distToLastHurdle < minHurdleSpacing) {
              newHurdlePos = lastHurdlePos + minHurdleSpacing;
            }

            hurdle.remove(hurdles);
            hurdle.add(Hurdle(worldLocation: Offset(newHurdlePos, 0)));
          });
        }
      }

      for (Ground groundlet in ground) {
        if (groundlet.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            ground.remove(groundlet);
            ground.add(
              Ground(
                worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0,
                ),
              ),
            );
          });
        }
      }

      for (Cloud cloud in clouds) {
        if (cloud.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            clouds.remove(cloud);
            clouds.add(
              Cloud(
                worldLocation: Offset(
                  clouds.last.worldLocation.dx +
                      Random().nextInt(200) +
                      MediaQuery.of(context).size.width / worlToPixelRatio,
                  Random().nextInt(50) - 25.0,
                ),
              ),
            );
          });
        }
      }
      lastUpdateCall = worldController.lastElapsedDuration!;
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    gravityController.dispose();
    worldController.dispose();
    accelerationController.dispose();
    jumpVelocityController.dispose();
    runVelocityController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    for (GameObject object in [...clouds, ...ground, ...hurdle, bruin]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }

    return WillPopScope(
      key: _gameFormKey,
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _gameScaffoldKey,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              body: AnimatedContainer(
                duration: const Duration(milliseconds: 5000),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (bruin.state != BruinState.dead) {
                      bruin.jump();
                    }
                    if (bruin.state == BruinState.dead) {
                      _audioPlayer.stop();
                      _newGame();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ...children,
                      AnimatedBuilder(
                        animation: worldController,
                        builder: (context, _) {
                          return Positioned(
                            top: 200,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '${runDistance.toInt()}',
                                style: TextStyle(
                                  fontFamily: 'PressStart2P',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (runDistance ~/ dayNightOffest) % 2 == 0
                                          ? Colors.white
                                          : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 20,
                        top: 20,
                        child: Wrap(
                          children: [
                            IconButton(
                                style: getQuitButtonStyle(),
                                onPressed: () {
                                  _audioPlayer.stop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainMenuPage()));
                                },
                                icon: const Icon(Icons.clear)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isGameOver)
              Container(
                width: screenSize.longestSide,
                color: darkBruinBlue.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      child: Text(
                        'Game Over',
                        style: TextStyle(
                            fontSize: 34,
                            color: Colors.white,
                            fontFamily: 'PressStart2P',
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {
                        onPlayAgain();
                        _audioPlayer.stop();
                      },
                      child: const Text(
                        'Play Again?',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'PressStart2P',
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {
                        _audioPlayer.stop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainMenuPage()));
                      },
                      child: const Text(
                        'Quit',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'PressStart2P',
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
