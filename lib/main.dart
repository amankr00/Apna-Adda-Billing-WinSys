import 'package:flutter/material.dart';

void main() {
  runApp(BillingApp());
}

class BillingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BillingPage(),
    );
  }
}

// Apna Adda The Roof Top Cafe - Billing Section

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final _formKey = GlobalKey<FormState>();
  String customerName = '';
  String phoneNumber = '';
  String address = '';

  // Complete list of menu items with their categories
  final Map<String, List<String>> menuItems = {
    'Indian': [
      'Sahi Paneer',
      'Paneer Masala',
      'Paneer Butter Masala',
      'Paneer Do Pyaza',
      'Paneer Handi',
      'Paneer Kadhai',
      'Paneer Tikka Butter Masala',
      'Mutter Paneer',
      'Mushroom Butter Masala',
      'Mushroom Do-Pyaza',
      'Mushroom Kadhai',
      'Mushroom Handi',
      'Mix Veg',
      'Chicken Punjabi',
      'Chicken Masala',
      'Chicken Butter Masala',
      'Chicken Do-Pyaza',
      'Chicken Kadhai',
      'Chicken Handi',
      'Chicken Tikka Masala',
      'Chicken Dehati',
      'Egg Curry',
      'Egg Masala',
      'Egg Do-Pyaza',
    ],
    'Naan': [
      'Tandoori Roti',
      'Butter Tandoori Roti',
      'Plain Naan',
      'Butter Naan',
      'Garlic Naan',
      'Paneer Stuff Naan',
    ],
    'Dal': ['Dal Fry', 'Dal Tarka', 'Dal Makhani'],
    'Rice': ['Plain Rice', 'Jeera Rice', 'Veg Rice'],
    'Salads': ['Onion Salad', 'Green Salad'],
    'Sizzlers': [
      'Veg Chinese Sizzler(A Combination)',
      'Non Veg Chinese Sizzler',
    ]
  };

  // Corresponding prices for each item
  final Map<String, List<double>> menuPrices = {
    'Indian': [
      349.00,
      279.00,
      299.00,
      299.00,
      309.00,
      299.00,
      329.00,
      269.00,
      299.00,
      299.00,
      309.00,
      309.00,
      199.00,
      369.00,
      319.00,
      359.00,
      329.00,
      359.00,
      359.00,
      369.00,
      389.00,
      139.00,
      149.00,
      199.00
    ],
    'Naan': [25.00, 30.00, 40.00, 45.00, 59.00, 79.00],
    'Dal': [139.00, 149.00, 159.00],
    'Rice': [99.00, 199.00, 139.00],
    'Salads': [49.00, 89.00],
    'Sizzlers': [299.00, 399.00],
  };

  // Holds the quantity for each item
  final Map<String, int> itemQuantities = {
    'Sahi Paneer': 0,
    'Paneer Masala': 0,
    'Paneer Butter Masala': 0,
    'Paneer Do Pyaza': 0,
    'Paneer Handi': 0,
    'Paneer Kadhai': 0,
    'Paneer Tikka Butter Masala': 0,
    'Mutter Paneer': 0,
    'Mushroom Butter Masala': 0,
    'Mushroom Do-Pyaza': 0,
    'Mushroom Kadhai': 0,
    'Mushroom Handi': 0,
    'Mix Veg': 0,
    'Chicken Punjabi': 0,
    'Chicken Masala': 0,
    'Chicken Butter Masala': 0,
    'Chicken Do-Pyaza': 0,
    'Chicken Kadhai': 0,
    'Chicken Handi': 0,
    'Chicken Tikka Masala': 0,
    'Chicken Dehati': 0,
    'Egg Curry': 0,
    'Egg Masala': 0,
    'Egg Do-Pyaza': 0,
    'Tandoori Roti': 0,
    'Butter Tandoori Roti': 0,
    'Plain Naan': 0,
    'Butter Naan': 0,
    'Garlic Naan': 0,
    'Paneer Stuff Naan': 0,
    'Dal Fry': 0,
    'Dal Tarka': 0,
    'Dal Makhani': 0,
    'Plain Rice': 0,
    'Jeera Rice': 0,
    'Veg Rice': 0,
    'Onion Salad': 0,
    'Green Salad': 0,
    'Veg Chinese Sizzler(A Combination)': 0,
    'Non Veg Chinese Sizzler': 0,
  };

  // Function to calculate total price
  double calculateTotal() {
    double total = 0.0;
    menuItems.forEach((category, items) {
      for (int i = 0; i < items.length; i++) {
        total += itemQuantities[items[i]]! * menuPrices[category]![i];
      }
    });
    return total;
  }

  // Generate a bill summary
  String generateBillSummary() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("Customer: $customerName");
    buffer.writeln("Phone: $phoneNumber");
    buffer.writeln("Address: $address\n");
    buffer.writeln("Items:");

    menuItems.forEach((category, items) {
      for (int i = 0; i < items.length; i++) {
        if (itemQuantities[items[i]]! > 0) {
          buffer.writeln(
              "${items[i]} (x${itemQuantities[items[i]]}) - \Rs${(menuPrices[category]![i] * itemQuantities[items[i]]!).toStringAsFixed(2)}");
        }
      }
    });

    buffer.writeln("\nTotal: \Rs${calculateTotal().toStringAsFixed(2)}");
    return buffer.toString();
  }

  // UI starts here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Apna Adda Billing",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  customerInfoFields(),
                  SizedBox(height: 20),
                  Divider(),
                  menuSection('Indian'),
                  Divider(),
                  menuSection('Naan'),
                  Divider(),
                  menuSection('Dal'),
                  Divider(),
                  menuSection('Rice'),
                  Divider(),
                  menuSection('Salads'),
                  Divider(),
                  menuSection('Sizzlers'),
                  SizedBox(height: 20),
                  Text(
                    'Total: \Rs${calculateTotal().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Bill Summary',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Text(generateBillSummary()),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Generate Bill'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for customer information fields
  Column customerInfoFields() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Customer Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter customer name';
            }
            return null;
          },
          onSaved: (value) {
            customerName = value ?? '';
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
          onSaved: (value) {
            phoneNumber = value ?? '';
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
          onSaved: (value) {
            address = value ?? '';
          },
        ),
      ],
    );
  }

  // Helper Widget for Menu Category with Quantity Control
  Column menuSection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$category Items',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Column(
          children: menuItems[category]!.map((item) {
            return ListTile(
              title: Text(item),
              subtitle: Text(
                  'Rs-${menuPrices[category]![menuItems[category]!.indexOf(item)].toStringAsFixed(2)}'),
              trailing: quantityControl(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper Widget for Quantity Control
  Widget quantityControl(String item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            setState(() {
              if (itemQuantities[item]! > 0) {
                itemQuantities[item] = itemQuantities[item]! - 1;
              }
            });
          },
        ),
        Text(itemQuantities[item].toString()),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {
            setState(() {
              itemQuantities[item] = itemQuantities[item]! + 1;
            });
          },
        ),
      ],
    );
  }
}