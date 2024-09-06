import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ApnaAddaSys(title: 'Apna Adda Windows System'),
    );
  }
}

// Menu Page, Cart Page, Billing Page, Print Bill
class ApnaAddaSys extends StatefulWidget {
  const ApnaAddaSys({super.key, required this.title});
  final String title;

  @override
  State<ApnaAddaSys> createState() => _ApnaAddaSysState();
}

class _ApnaAddaSysState extends State<ApnaAddaSys> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize the PageController
  }

  void _navigateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left-side Menu
          Container(
            decoration: BoxDecoration(color: Colors.deepPurple[100]),
            width: 200, // Fixed width for the menu
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Menu
                cont('Menu', () => _navigateToPage(0)),
                const SizedBox(height: 20),
                // Cart
                cont('Cart', () => _navigateToPage(1)),
                const SizedBox(height: 20),
                // Billing
                cont('Billing', () => _navigateToPage(2)),
                const SizedBox(height: 20),
                // Print Bill
                cont('Print Bill', () => _navigateToPage(3)),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Expanded content area for PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                Container(
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Menu Page',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: const Center(
                    child: Text(
                      'Cart Page',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Colors.orange,
                  child: const Center(
                    child: Text(
                      'Billing Page',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      'Print Bill Page',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function for creating the buttons
  Widget cont(String text, VoidCallback onPressed) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepPurple[200],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
