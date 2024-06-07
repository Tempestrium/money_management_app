import 'package:flutter/material.dart';
import 'product.dart'; // Import your product model if it's defined in a separate file

class SavedHistoryScreen extends StatelessWidget {
  final List<HistoryItem> history;

  const SavedHistoryScreen({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Histories'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final savedItem = history[index];
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(savedItem.name),
              children: savedItem.products.map((product) {
                return ListTile(
                  title: Text('${product.name} x${product.quantity}'),
                  subtitle: Text(
                      'Total: ₱${(product.price * product.quantity).toStringAsFixed(2)}'),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
