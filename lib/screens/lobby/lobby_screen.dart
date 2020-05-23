import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/database.dart';
import '../sudoku/sudoku_screen.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = '/lobby';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  int roomCode;
  @override
  void initState() {
    final db = Provider.of<Database>(context, listen: false);
    roomCode = db.roomCode;
    Firestore.instance
        .collection('games')
        .document(db.id)
        .snapshots()
        .listen(startGame);

    super.initState();
  }

  void _copyRoomCode(BuildContext context) {
    Clipboard.setData(
      ClipboardData(text: '$roomCode'),
    );
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Room code copied to clipboard!'),
      ),
    );
  }

  void startGame(DocumentSnapshot snapshot) {
    if (snapshot.data['player_2_joined'])
      Navigator.of(context).pushReplacementNamed(SudokuScreen.routeName);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Builder(
        builder: (context) => SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                Text(
                  "Room code:",
                  style: Theme.of(context).textTheme.headline2,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () => _copyRoomCode(context),
                  child: Text(
                    "$roomCode",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Spacer(flex: 1),
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  "Waiting for the other player to join...",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
