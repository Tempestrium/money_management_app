import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'product.dart';

class HistoryOverviewScreen extends StatefulWidget {
  final List<HistoryItem> history;

  const HistoryOverviewScreen({Key? key, required this.history}) : super(key: key);

  @override
  _HistoryOverviewScreenState createState() => _HistoryOverviewScreenState();
}

class _HistoryOverviewScreenState extends State<HistoryOverviewScreen> {
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
      appBar: AppBar(
        title: const Text('History Overview'),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/history.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.history.length,
                  itemBuilder: (context, index) {
                    final savedItem = widget.history[index];
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(savedItem.name), // Display the saved name
                        children: [
                          ...savedItem.products.map((product) {
                            return ListTile(
                              title: Text('${product.name} x${product.quantity}'),
                              subtitle: Text(
                                  'Total: ₱${(product.price * product.quantity).toStringAsFixed(2)}'),
                            );
                          }).toList(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      widget.history.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _navigateToProductListScreen,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Manage Budget'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}