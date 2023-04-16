import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/sessionpages/join_session_page.dart';

import '../../styles/colours.dart';
import '../../styles/session_pages_styles.dart';

class SessionJoinedPage extends StatefulWidget {
  const SessionJoinedPage({Key? key}) : super(key: key);

  @override
  State<SessionJoinedPage> createState() => _SessionJoinedPageState();
}

class _SessionJoinedPageState extends State<SessionJoinedPage> {
  final GlobalKey<FormState> _sessionJoinedFormKey = GlobalKey<FormState>();
  String yourPlayerName = "Player 1";
  String playerName2 = "You";
  String playerName3 = "Player 3";
  String playerName4 = "Player 4";

  final TextEditingController _joinCodeFieldController =
      joinCodeFieldController;

  // @override
  // void initState() {
  //   super.initState();
  //   // joinCode = Random().nextInt(900000) + 100000;
  //   // _joinCodeFieldController = TextEditingController(text: "$joinCode");
  // }
  //
  // @override
  // void dispose() {
  //   //Release memory allocated to the fields after the page is removed
  //   // _joinCodeFieldController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _sessionJoinedFormKey,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: lightBruinBlue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'SESSION JOINED',
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
                    spacing: 25,
                    children: [
                      Row(
                        children: const [
                          FittedBox(
                            child: Text(
                              textAlign: TextAlign.center,
                              'Waiting For \nParty Leader...',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'PressStart2P',
                              ),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: Column(children: [
                          generatedCodeTextFieldStyle(_joinCodeFieldController),
                        ]),
                      ),
                      //CREATE STYLE
                      Wrap(
                          direction: Axis.vertical,
                          spacing: 15,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            playerCard(bluePlayerColor, yourPlayerName),
                            playerCard(redPlayerColor, playerName2),
                            playerCard(greenPlayerColor, playerName3),
                            playerCard(yellowPlayerColor, playerName4),
                          ]),
                    ],
                  ),
                ],
              ),
            )));
  }
}
