import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';
import 'package:run_bruin_run/styles/colours.dart';

import '../../styles/button_styles.dart';
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
    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));
    worldController.addListener(_update);
    // worldController.forward();
    worldController.stop();
    bruin.die();
    Fluttertoast.showToast(
        msg: "Tap to play!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        fontSize: 40,
        backgroundColor: darkBruinBlue);
    // _die();
  }

  void onPlayAgain() {
    setState(() {
      _isGameOver = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyGame()));
    // Reset the game here
  }

  void _die() {
    setState(() {
      worldController.stop();
      bruin.die();

      Source gameOverSound = AssetSource('sounds/smb_gameover.wav');
      _audioPlayer.play(gameOverSound);
      _isGameOver = true;
    });
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

      final numHurdlesCleared = hurdle.length - 1; // ignore first hurdle
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
            // calculate distance to last hurdle added
            double lastHurdlePos = hurdle.last.worldLocation.dx;
            double newHurdlePos = runDistance +
                Random().nextInt(200) +
                screenSize.width / worlToPixelRatio;
            double distToLastHurdle = newHurdlePos - lastHurdlePos;

            // choose new position for hurdle if too close to last hurdle
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

    return Stack(
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
                            left: screenSize.width / 2 - 60,
                            top: 100,
                            child: Text(
                              'Score:${runDistance.toInt()}',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: (runDistance ~/ dayNightOffest) % 2 == 0
                                    ? Colors.white
                                    : Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: worldController,
                        builder: (context, _) {
                          return Positioned(
                            left: screenSize.width / 2 - 90,
                            top: 120,
                            child: Text(
                              'High Score:$highScore',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: (runDistance ~/ dayNightOffest) % 2 == 0
                                    ? Colors.white
                                    : Colors.white,
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
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            _die();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Change Physics"),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 25,
                                        width: 280,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Gravity:"),
                                            SizedBox(
                                              height: 25,
                                              width: 75,
                                              child: TextField(
                                                controller: gravityController,
                                                key: UniqueKey(),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 25,
                                        width: 280,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Acceleration:"),
                                            SizedBox(
                                              height: 25,
                                              width: 75,
                                              child: TextField(
                                                controller:
                                                    accelerationController,
                                                key: UniqueKey(),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 25,
                                        width: 280,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Initial Velocity:"),
                                            SizedBox(
                                              height: 25,
                                              width: 75,
                                              child: TextField(
                                                controller:
                                                    runVelocityController,
                                                key: UniqueKey(),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 25,
                                        width: 280,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Jump Velocity:"),
                                            SizedBox(
                                              height: 25,
                                              width: 75,
                                              child: TextField(
                                                controller:
                                                    jumpVelocityController,
                                                key: UniqueKey(),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 25,
                                        width: 280,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Day-Night Offset:"),
                                            SizedBox(
                                              height: 25,
                                              width: 75,
                                              child: TextField(
                                                key: UniqueKey(),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        gravity =
                                            int.parse(gravityController.text);
                                        acceleration = double.parse(
                                            accelerationController.text);
                                        initialVelocity = double.parse(
                                            runVelocityController.text);
                                        jumpVelocity = double.parse(
                                            jumpVelocityController.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Done",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                            style: getQuitButtonStyle(),
                            onPressed: () {
                              Fluttertoast.cancel();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainMenuPage()));
                            },
                            icon: const Icon(Icons.clear)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: TextButton(
                      onPressed: () {
                        _die();
                      },
                      child: const Text(
                        "Force Kill Bear",
                        style: TextStyle(color: Colors.red),
                      ),
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
                  onPressed: () => Navigator.of(context).pop(),
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
    );
  }
}
