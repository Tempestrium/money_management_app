import 'package:flutter/material.dart';
import 'history_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/front.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Start button
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryOverviewScreen(history: [],)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50), // Set the minimum size
                      backgroundColor: Colors.blueAccent, // Set the background color
                      foregroundColor: Colors.white, // Set the text color
                      textStyle: const TextStyle(
                        fontSize: 20, // Set the font size
                      ),
                    ),
                    child: const Text('Start Calculating!'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
