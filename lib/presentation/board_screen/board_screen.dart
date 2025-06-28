import 'package:flutter/material.dart';
import 'package:front_mission/core/di/di_setup.dart';
import 'package:front_mission/presentation/write_borad_screen/write_board_screen.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text('게시판')),
          FloatingActionButton(
            onPressed: () async {
              final success = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriteBoardScreen(viewModel: getIt()),
                ),
              );
              if (success != null && success) {
                setState(() {});
              }
            },
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.mode_edit_outline_sharp),
          ),
        ],
      ),
    );
  }
}
