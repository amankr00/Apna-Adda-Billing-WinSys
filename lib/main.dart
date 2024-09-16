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

  final Map<String, List<String>> menuItems = {
    'Indian': [
      'Sahi Paneer',
      'Paneer Masala',
      'Paneer Butter Masala',
      // Add more items
    ],
    'Naan': ['Tandoori Roti', 'Butter Tandoori Roti'],
    'Rice': ['Plain Rice', 'Jeera Rice'],
    'Salads': ['Onion Salad', 'Green Salad'],
    // Add more categories
  };

  final Map<String, List<double>> menuPrices = {
    'Indian': [349.00, 279.00, 299.00],
    'Naan': [25.00, 30.00],
    'Rice': [99.00, 199.00],
    'Salads': [49.00, 89.00],
    // Add prices for other categories
  };

  final Map<String, int> itemQuantities = {
    'Sahi Paneer': 0,
    'Paneer Masala': 0,
    'Paneer Butter Masala': 0,
    'Tandoori Roti': 0,
    'Butter Tandoori Roti': 0,
    'Plain Rice': 0,
    'Jeera Rice': 0,
    'Onion Salad': 0,
    'Green Salad': 0,
  };

  double calculateTotal() {
    double total = 0.0;
    menuItems.forEach((category, items) {
      for (int i = 0; i < items.length; i++) {
        total += itemQuantities[items[i]]! * menuPrices[category]![i];
      }
    });
    return total;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Apna Adda Billing",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple[100],
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
                  ProfileIcon(),
                  customerInfoFields(),
                  SizedBox(height: 20),
                  Divider(),
                  menuSection('Indian'),
                  Divider(),
                  menuSection('Naan'),
                  Divider(),
                  menuSection('Rice'),
                  Divider(),
                  menuSection('Salads'),
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
                        showBillSummaryDialog(context);
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

  void showBillSummaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Bill Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Bill(
              customerName: customerName,
              phoneNumber: phoneNumber,
              address: address,
              total: calculateTotal(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Bill class to display the summary in a similar style to an Uber receipt
class Bill extends StatelessWidget {
  final String customerName;
  final String phoneNumber;
  final String address;
  final double total;

  Bill({
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apna Adda The Roof Top Cafe',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Divider(),
            Text('Customer: $customerName'),
            Text('Phone: $phoneNumber'),
            Text('Address: $address'),
            SizedBox(height: 10),
            Divider(),
            Text(
              'Total Bill: \Rs${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Divider(),
            Text('Thank you for visiting Apna Adda!'),
          ],
        ),
      ),
    );
  }
}

// ProfileIcon widget to represent the user's profile
class ProfileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(
          'https://example.com/profile_image.jpg'), // Replace with actual image URL
    );
  }
}
