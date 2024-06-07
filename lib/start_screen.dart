import 'package:flutter/material.dart';
import 'product_list_screen.dart'; // Make sure to import ProductListScreen

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _budgetController = TextEditingController();

  void _navigateToProductListScreen() async {
    double budget = 0.0; // Default budget

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Budget'),
          content: TextField(
            controller: _budgetController,
            decoration: const InputDecoration(labelText: 'Budget'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String budgetString = _budgetController.text.replaceAll(',', '');
                budget = double.tryParse(budgetString)?? 0.0;
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );

    if (budget > 0) { // Ensure budget is greater than 0 before navigating
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductListScreen(budget: budget)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid budget.')),
      );
    }
  }

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
                    onPressed: _navigateToProductListScreen,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50), // Set the minimum size
                      backgroundColor: Colors.blueAccent, // Set the background color
                      foregroundColor: Colors.white, // Set the text color
                      textStyle: const TextStyle(
                        fontSize: 20, // Set the font size
                      ),
                    ),
                    child: const Text('Start Calculating'),
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
