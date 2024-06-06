import 'package:flutter/material.dart';
import 'product.dart'; // Make sure to import the updated product.dart file
import 'history_screen.dart';


class ProductListScreen extends StatefulWidget {
  final double budget;

  const ProductListScreen({Key? key, required this.budget}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> _products = [];
  final List<Product> _filteredProducts = [];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  double _totalExpenses = 0.0;
  late double _budget;
  final List<HistoryItem> _history = [];

  @override
  void initState() {
    super.initState();
    _budget = widget.budget;
  }


  void _addProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 1;

    //Error Handling for When items have exceeded the budget
    if (name.isNotEmpty && price > 0 && quantity > 0) {
      if (_budget - (price * quantity) < 0) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Budget Exceeded'),
              content: const Text(
                  'This is the hardest part remove some on your cart and follow your set budget. You are not rich enough'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      setState(() {
        _products.add(Product(name, price, quantity));
        _totalExpenses += price * quantity;
        _budget -= price * quantity;
      });

      _nameController.clear();
      _priceController.clear();
      _quantityController.clear();
    }
  }

  void _deleteProduct(int index) {
    setState(() {
      final product = _products[index];
      _totalExpenses -= product.price * product.quantity;
      _budget += product.price * product.quantity;
      _products.removeAt(index);
    });
  }

  void _editProduct(int index) {
    final product = _products[index];
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                final name = _nameController.text;
                final price = double.tryParse(_priceController.text) ?? 0.0;
                final quantity = int.tryParse(_quantityController.text) ?? 1;

                if (name.isNotEmpty && price > 0 && quantity > 0) {
                  setState(() {
                    final product = _products[index];
                    _totalExpenses -= product.price * product.quantity;
                    _budget += product.price * product.quantity;
                    _products[index] = Product(name, price, quantity);
                    _totalExpenses += price * quantity;
                    _budget -= price * quantity;
                  });

                  _nameController.clear();
                  _priceController.clear();
                  _quantityController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _setBudget() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: _budget.toString()),
                decoration: const InputDecoration(labelText: 'Budget'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _budget = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _applyPriceRangeFilter(double minPrice, double maxPrice) {
    setState(() {
      _filteredProducts.clear(); // Clear the existing filtered list
      _products.forEach((product) {
        if (product.price >= minPrice && product.price <= maxPrice) {
          _filteredProducts.add(product); // Add the product to the filtered list if it meets the criteria
        }
      });
    });
  }

  void _saveHistory() {
    showDialog(
      context: context,
      builder: (context) {
        final _historyNameController = TextEditingController();
        return AlertDialog(
          title: const Text('Save to History'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _historyNameController,
                decoration: const InputDecoration(labelText: 'Budget Name'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final historyName = _historyNameController.text;
                if (historyName.isNotEmpty) {
                  setState(() {
                    _history.add(HistoryItem(historyName, _products));
                  });
                  Navigator.of(context).pop();

                  // Navigate to HistoryOverviewScreen with the current history
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryOverviewScreen(history: _history),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a history name.')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Product'),
        backgroundColor: Colors.blueAccent.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  double minPrice = 0.0;
                  double maxPrice = 0.0;

                  return AlertDialog(
                    title: const Text('Price Range Filtering'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'Minimum Price'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            minPrice = double.tryParse(value) ?? 0.0;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Maximum Price'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            maxPrice = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _applyPriceRangeFilter(minPrice, maxPrice);
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: _setBudget,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/product.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20), // Add space between text fields
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[200], // Background color for product name field
                          borderRadius: BorderRadius.circular(10.0), // Border radius
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0), // Padding
                            border: InputBorder.none, // Remove border
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Add space between text fields
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[300], // Background color for price field
                          borderRadius: BorderRadius.circular(10.0), // Border radius
                        ),
                        child: TextField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0), // Padding
                            border: InputBorder.none, // Remove border
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 20), // Add space between text fields
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[400], // Background color for quantity field
                          borderRadius: BorderRadius.circular(10.0), // Border radius
                        ),
                        child: TextField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0), // Padding
                            border: InputBorder.none, // Remove border
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 20), // Add space between text fields
                      // Rest of your widgets...
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent), // Set the background color
                    ),
                    child: const Text('Add Product'),
                    onPressed: _addProduct,
                  ),
                  const SizedBox(height: 20),
                  Text('Total Expenses: ₱${_totalExpenses.toStringAsFixed(2)}'),
                  Text('Remaining Budget: ₱${_budget.toStringAsFixed(2)}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.yellowAccent), // Set the background color
                    ),
                    child: const Text('Save to History'),
                    onPressed: _saveHistory,
                  ),
                  const SizedBox(height: 20),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5, // Half of the screen height
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final Color cardColor = index % 2 == 0
                            ? Colors.green.shade50
                            : Colors.green.shade100;
                        return Card(
                          color: cardColor,
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            title: Text('${product.name} x${product.quantity}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Total: ₱${(product.price * product.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 16)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () => _editProduct(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteProduct(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}