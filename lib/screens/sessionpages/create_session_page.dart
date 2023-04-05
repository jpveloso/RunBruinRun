import 'dart:math';

import 'package:flutter/material.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../../styles/session_pages_styles.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({Key? key}) : super(key: key);

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _formKey = GlobalKey<FormState>();
  String yourPlayerName = "You";
  String playerName2 = "Player 2";
  String playerName3 = "Player 3";
  String playerName4 = "Player 4";

  late int joinCode;
  TextEditingController _joinCodeFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    joinCode = Random().nextInt(900000) + 100000;
    _joinCodeFieldController = TextEditingController(text: "$joinCode");
  }

  @override
  void dispose() {
    //Release memory allocated to the fields after the page is removed
    _joinCodeFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: lightBruinBlue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'CREATE SESSION',
                    style: TextStyle(
                      fontSize: 27,
                      color: darkBruinBlue,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  const SizedBox(height: 50),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 30,
                    children: [
                      const Text(
                        'Join Code',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: Column(children: [
                          generatedCodeTextFieldStyle(_joinCodeFieldController),
                        ]),
                      ),
                      ElevatedButton(
                          style: getButtonStyle(),
                          onPressed: () {
                            setState(() {
                              joinCode = Random().nextInt(900000) + 100000;
                              _joinCodeFieldController =
                                  TextEditingController(text: "$joinCode");
                            });
                          },
                          child: const Text(
                            'New Code',
                            style: TextStyle(fontSize: 20),
                          )),
                      //CREATE STYLE
                      Wrap(
                          direction: Axis.vertical,
                          spacing: 15,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            playerCardAndBtn(
                                bluePlayerColor, yourPlayerName, "Play"),
                            playerCardAndBtn(
                                redPlayerColor, playerName2, "Kick"),
                            playerCardAndBtn(
                                greenPlayerColor, playerName3, "Kick"),
                            playerCardAndBtn(
                                yellowPlayerColor, playerName4, "Kick"),
                          ]),
                    ],
                  ),
                ],
              ),
            )));
  }
}
