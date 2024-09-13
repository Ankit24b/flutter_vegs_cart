import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_cart/provider.dart/cart_provider.dart';
import 'package:vegetables_cart/screens/products_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


Future main() async{

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),        // It will provide the all required methods
      child: Builder(builder: (BuildContext context) {
        return const MaterialApp(
          title: 'Vegetables App',
          debugShowCheckedModeBanner: false,
          home: ProductsScreen(),
        );
      },),
      );
  }
}