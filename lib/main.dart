import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    'Indian': ['Sahi Paneer', 'Paneer Masala', 'Paneer Butter Masala'],
    'Naan': ['Tandoori Roti', 'Butter Tandoori Roti'],
    'Rice': ['Plain Rice', 'Jeera Rice'],
    'Salads': ['Onion Salad', 'Green Salad'],
  };

  final Map<String, List<double>> menuPrices = {
    'Indian': [349.00, 279.00, 299.00],
    'Naan': [25.00, 30.00],
    'Rice': [99.00, 199.00],
    'Salads': [49.00, 89.00],
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

  Future<Uint8List> _generateBillPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Apna Adda The Roof Top Cafe',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
              pw.Divider(),
              pw.Text('Customer: $customerName'),
              pw.Text('Phone: $phoneNumber'),
              pw.Text('Address: $address'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Text('Items Purchased:'),
              pw.ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  String category = menuItems.keys.elementAt(index);
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('$category:'),
                      pw.ListView.builder(
                        itemCount: menuItems[category]!.length,
                        itemBuilder: (context, itemIndex) {
                          String item = menuItems[category]![itemIndex];
                          int quantity = itemQuantities[item]!;
                          if (quantity > 0) {
                            return pw.Text(
                              '$item (x$quantity) - Rs${(menuPrices[category]![itemIndex] * quantity).toStringAsFixed(2)}',
                            );
                          }
                          return pw.Container();
                        },
                      ),
                    ],
                  );
                },
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total: Rs${calculateTotal().toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Text('Thank you for visiting Apna Adda!'),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  void _printOrSavePdf() async {
    Uint8List pdfData = await _generateBillPdf();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
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
                    'Total: Rs${calculateTotal().toStringAsFixed(2)}',
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
                        _printOrSavePdf();
                      }
                    },
                    child: Text('Generate and Print Bill'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
