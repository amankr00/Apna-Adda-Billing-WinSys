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
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BillingPage(),
    );
  }
}

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}
class _BillingPageState extends State<BillingPage> {
  final _formKey = GlobalKey<FormState>();
  String customerName = '';
  String phoneNumber = '';
  String address = '';
  List<Map<String, dynamic>> items = [];

  final List<String> menuItems = [
    'Sahi Paneer',
    'Paneer Masala',
    'Paneer butter masala',
    'Paneer do pyaza',
    'Paneer handi',
    'Paneer kandhai',
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
    'Egg Do-Payaza',
    // New Breads category
    'Tandoori Roti',
    'Butter Tandoori Roti',
    'Plain Naan',
    'Butter Naan',
    'Garlic Naan',
    'Paneer Stuff Naan',
    // Dal 
    'Dal Fry',
    'Dal Tarka',
    'Dal Makhani'
    // Rice
    'Plain Rice',
    'Jeera Rice',
    'Veg Rice',
    // Salads
    'Onion Salad',
    'Green Salad',
    // Sizzler
    'Veg Chinese Sizzler(A Combination)',
    'Non Veg Chinese Sizzler',

  ];

  final List<double> menuPrices = [
    349.00, 279.00, 299.00, 299.00, 309.00, 299.00, 329.00, 269.00, 299.00,
    299.00, 309.00, 309.00, 199.00, 369.00, 319.00, 359.00, 329.00, 359.00,
    359.00, 369.00, 389.00, 139.00, 149.00, 199.00,
    // Prices for new Breads category
    25.00, 30.00, 40.00, 45.00, 59.00, 79.00,
    // Dal
    139.00 , 149.00 , 159.00 , 
    // Rice 
    99.00 ,  199.00 , 139.00,
    // Salads
    49.00 , 89.00 
  ];

  String? selectedItem;
  int itemQuantity = 1;
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = menuItems;
  }

  // Function to calculate total price
  double calculateTotal() {
    return items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Function to generate bill summary
  String generateBillSummary() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("Customer: $customerName");
    buffer.writeln("Phone: $phoneNumber");
    buffer.writeln("Address: $address\n");
    buffer.writeln("Items:");
    for (var item in items) {
      buffer.writeln(
          "${item['name']} (x${item['quantity']}) - \$${(item['price'] * item['quantity']).toStringAsFixed(2)}");
    }
    buffer.writeln("\nTotal: \$${calculateTotal().toStringAsFixed(2)}");
    return buffer.toString();
  }

  // Add selected item to the list
  void addItem() {
    if (selectedItem != null && itemQuantity > 0) {
      int index = menuItems.indexOf(selectedItem!);
      double price = menuPrices[index];
      setState(() {
        items.add({
          'name': selectedItem!,
          'quantity': itemQuantity,
          'price': price,
        });
        selectedItem = null;
        itemQuantity = 1;
      });
    }
  }

  // Remove item from the list
  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  // Filter the dropdown items based on search input
  void filterItems(String query) {
    setState(() {
      filteredItems = menuItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // UI starts here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.receipt),
            SizedBox(width: 10),
            Text(
              "Restaurant Billing",
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        elevation: 0,
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
                  SizedBox(height: 60),
                  Text(
                    'Customer Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
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
                  SizedBox(height: 20),
                  Divider(),
                  Text(
                    'Order Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Item',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.fastfood),
                    ),
                    value: selectedItem,
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                      });
                    },
                    items: filteredItems.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: itemQuantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        itemQuantity = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: addItem,
                    icon: Icon(Icons.add),
                    label: Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (items.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Added Items:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ...items.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> item = entry.value;
                          return ListTile(
                            leading: Icon(Icons.restaurant_menu),
                            title: Text("${item['name']} (x${item['quantity']})"),
                            subtitle: Text(
                                "\Rs-${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeItem(index),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
}
