import 'package:flutter/material.dart';

void main() {
  runApp(const BillingApp());
}

class BillingApp extends StatelessWidget {
  const BillingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BillingPage(),
    );
  }
}

class BillingPage extends StatefulWidget {
  const BillingPage({Key? key}) : super(key: key);

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final _formKey = GlobalKey<FormState>();
  String customerName = '';
  String phoneNumber = '';
  String address = '';

  // Menu items and prices defined in one place to avoid redundancy
  final Map<String, List<Map<String, dynamic>>> menuData = {
    'Indian': [
      {'name': 'Sahi Paneer', 'price': 349.00},
      {'name': 'Paneer Masala', 'price': 279.00},
      {'name': 'Paneer Butter Masala', 'price': 299.00},
      {'name': 'Dal Makhani', 'price': 199.00},
      {'name': 'Jeera Rice', 'price': 120.00},
      {'name': 'Biryani', 'price': 249.00},
      {'name': 'Butter Chicken', 'price': 349.00},
    ],
    'Naan': [
      {'name': 'Tandoori Roti', 'price': 25.00},
      {'name': 'Butter Tandoori Roti', 'price': 30.00},
      {'name': 'Plain Naan', 'price': 35.00},
      {'name': 'Butter Naan', 'price': 45.00},
      {'name': 'Garlic Naan', 'price': 50.00},
      {'name': 'Laccha Paratha', 'price': 50.00},
    ],
    'Italian': [
      {'name': 'Margherita Pizza', 'price': 299.00},
      {'name': 'Farmhouse Pizza', 'price': 349.00},
      {'name': 'Pasta Alfredo', 'price': 229.00},
      {'name': 'Pasta Arrabbiata', 'price': 229.00},
      {'name': 'Lasagna', 'price': 349.00},
      {'name': 'Garlic Bread', 'price': 99.00},
    ],
    'Chinese': [
      {'name': 'Spring Rolls', 'price': 149.00},
      {'name': 'Hakka Noodles', 'price': 199.00},
      {'name': 'Chilli Chicken', 'price': 249.00},
      {'name': 'Manchurian', 'price': 199.00},
      {'name': 'Schezwan Fried Rice', 'price': 199.00},
      {'name': 'Sweet and Sour Pork', 'price': 299.00},
    ],
    'Beverages': [
      {'name': 'Lemonade', 'price': 50.00},
      {'name': 'Iced Tea', 'price': 70.00},
      {'name': 'Coke', 'price': 40.00},
      {'name': 'Pepsi', 'price': 40.00},
      {'name': 'Milkshake', 'price': 120.00},
      {'name': 'Smoothie', 'price': 150.00},
    ],
    'Desserts': [
      {'name': 'Ice Cream', 'price': 100.00},
      {'name': 'Brownie', 'price': 150.00},
      {'name': 'Cheesecake', 'price': 200.00},
      {'name': 'Gulab Jamun', 'price': 50.00},
      {'name': 'Rasmalai', 'price': 80.00},
      {'name': 'Tiramisu', 'price': 250.00},
    ],
  };

  // Initialize item quantities to 0
  final Map<String, int> itemQuantities = {};

  @override
  void initState() {
    super.initState();
    // Initialize quantities for all menu items
    menuData.forEach((category, items) {
      for (var item in items) {
        itemQuantities[item['name']] = 0;
      }
    });
  }

  // Calculate the total price of the selected items
  double calculateTotal() {
    double total = 0.0;
    menuData.forEach((category, items) {
      for (var item in items) {
        total += itemQuantities[item['name']]! * item['price'];
      }
    });
    return total;
  }

  // Generate a bill summary
  String generateBillSummary() {
    final buffer = StringBuffer();
    buffer.writeln("Customer: $customerName");
    buffer.writeln("Phone: $phoneNumber");
    buffer.writeln("Address: $address\n");
    buffer.writeln("Items:");

    menuData.forEach((category, items) {
      for (var item in items) {
        if (itemQuantities[item['name']]! > 0) {
          buffer.writeln(
              "${item['name']} (x${itemQuantities[item['name']]}) - \Rs${(item['price'] * itemQuantities[item['name']]!).toStringAsFixed(2)}");
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
        title: const Text(
          "Apna Adda Billing",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple[100],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.98,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Profile icon at the top
                const ProfileIcon(),
                customerInfoFields(),
                const SizedBox(height: 20),
                const Divider(),
                // Display each menu section
                ...menuData.keys.map((category) => Column(
                      children: [
                        menuSection(category),
                        const Divider(),
                      ],
                    )),
                const SizedBox(height: 20),
                // Display the total price
                Text(
                  'Total: \Rs${calculateTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 20),
                // Button to generate the bill
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Bill Summary',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text(generateBillSummary()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Generate Bill'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for customer information input fields
  Widget customerInfoFields() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
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
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
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
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
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

  // Widget for each menu section
  Widget menuSection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 10),
        ...menuData[category]!.map((item) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item['name']} (\Rs${item['price'].toStringAsFixed(2)})',
                    style: const TextStyle(fontSize: 16),
                  ),
                  quantityControl(item['name']),
                ],
              ),
              const SizedBox(height: 5),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Widget for quantity control buttons
  Widget quantityControl(String itemName) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            setState(() {
              if (itemQuantities[itemName]! > 0) {
                itemQuantities[itemName] = itemQuantities[itemName]! - 1;
              }
            });
          },
        ),
        Text(
          '${itemQuantities[itemName]}',
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            setState(() {
              itemQuantities[itemName] = itemQuantities[itemName]! + 1;
            });
          },
        ),
      ],
    );
  }
}

// Widget for displaying the profile icon
class ProfileIcon extends StatelessWidget {
  const ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: const CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage('assets/profile_icon.png'),
      ),
    );
  }
}
