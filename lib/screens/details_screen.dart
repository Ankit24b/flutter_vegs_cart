import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vegetable Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: const Color.fromARGB(255, 239, 238, 238),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
       

        children: [
          Center(child: Text('Product details'))

        ],
      ),
    );
  }
}
