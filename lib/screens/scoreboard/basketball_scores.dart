import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/loading_screens/loading_screen.dart';
import 'package:run_bruin_run/styles/button_styles.dart';

import '../../styles/colours.dart';
import '../basketball/basketBallGameScreen.dart';

class BBScoresPage extends StatelessWidget {
  const BBScoresPage({Key? key}) : super(key: key);

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        throw ArgumentError('Invalid month number: $month.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: lightBruinBlue,
      appBar: AppBar(
        backgroundColor: darkBruinBlue,
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            'HURDLE HIGHSCORES',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontFamily: 'PressStart2P',
            ),
          ),
        ),
        titleSpacing: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            flex: 1,
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('BBhighScores')
                    .doc(userId)
                    .collection('scores')
                    .orderBy('score', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LoadingScreen();
                  }

                  String formatDate(Timestamp timestamp) {
                    DateTime date = timestamp.toDate();
                    String day = _twoDigits(date.day);
                    String month = _getMonthName(date.month);
                    String year = date.year.toString();
                    String formattedTime =
                        '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
                    return '$day $month $year $formattedTime';
                  }

                  List<DataRow> rows = snapshot.data!.docs.map((doc) {
                    int score = doc.get('score');
                    Timestamp timestamp = doc.get('timestamp');
                    String formattedDate = formatDate(timestamp);
                    return DataRow(cells: [
                      DataCell(FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          score.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                      )),
                      DataCell(FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            // fontFamily: 'PressStart2P',
                          ),
                        ),
                      )),
                    ]);
                  }).toList();
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: DataTable(
                        dataRowColor: MaterialStateColor.resolveWith(
                                (states) => darkBruinBlue),
                        border: TableBorder.all(color: Colors.white),
                        headingRowColor: MaterialStateColor.resolveWith(
                                (states) => darkBruinBlue),
                        columns: const [
                          DataColumn(
                              label: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  'Score',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                              )),
                          DataColumn(
                              label: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  'Timestamp',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                              )),
                        ],
                        rows: rows,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 60.0),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            runSpacing: 20,
            children: [
              const Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Improve Your Score?',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: getSmallButtonStyle(),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen(
                      onQuit: () {
                        Navigator.of(context).pop();
                      },
                    )),
                  );
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
