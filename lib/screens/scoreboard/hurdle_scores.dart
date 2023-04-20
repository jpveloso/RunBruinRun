import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../styles/colours.dart';
import '../../styles/button_styles.dart';
import '../hurdle/game.dart';

class HurdleScoresPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hurdle Scores'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('score')
                  .orderBy('score', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                List<DataRow> rows = snapshot.data!.docs.map((doc) {
                  return DataRow(cells: [
                    DataCell(Text(doc['score'].toString())),
                  ]);
                }).toList();

                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Score')),
                    ],
                    rows: rows,
                  ),
                );
              },
            ),
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
    );
  }
}
