import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';
import 'package:run_bruin_run/screens/sessionpages/session_joined_page.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../../styles/session_pages_styles.dart';

final joinCodeFieldController = TextEditingController();

class JoinSessionPage extends StatefulWidget {
  const JoinSessionPage({Key? key}) : super(key: key);

  @override
  State<JoinSessionPage> createState() => _JoinSessionPageState();
}

class _JoinSessionPageState extends State<JoinSessionPage> {
  late final GlobalKey<FormState> _joinSessionFormKey;

  @override
  void initState(){
    super.initState();
    _joinSessionFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    //Release memory allocated to the fields after the page is removed
    joinCodeFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _joinSessionFormKey,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: lightBruinBlue,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'JOIN SESSION',
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
                        'Enter Join Code',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        height: 160,
                        child: Column(children: [
                          joinCodeTextFieldStyle(joinCodeFieldController),
                          const SizedBox(height: 30),
                        ]),
                      ),
                      ElevatedButton(
                          style: getButtonStyle(),
                          onPressed: () {
                            if (_joinSessionFormKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SessionJoinedPage()));
                            }
                          },
                          child: const Text(
                            'Join Session',
                            style: TextStyle(),
                          )),
                      ElevatedButton(
                          style: getButtonStyle(),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MainMenuPage()));
                          },
                          child: const Text('Back'))
                    ],
                  ),
                ],
              ),
            )));
  }
}
