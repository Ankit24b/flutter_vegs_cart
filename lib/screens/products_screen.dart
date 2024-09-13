import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:vegetables_cart/data_base.dart';
import 'package:vegetables_cart/models/products.dart';
import 'package:vegetables_cart/provider.dart/cart_provider.dart';
import 'package:vegetables_cart/screens/cart_screen.dart';
import 'package:vegetables_cart/screens/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  DBHelper? dbHelper = DBHelper();

  List<String> productName = [
    'Tomato',
    'Cucumber',
    'Potato',
    'Ladyfinger',
    'Mushrooms',
    'Onion',
    'carrot'
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://m.economictimes.com/thumb/msid-95423731,width-1200,height-900,resizemode-4,imgsize-56196/tomatoes-canva.jpg',
    'https://seed2plant.in/cdn/shop/products/saladcucumberseeds.jpg?v=1603435556&width=1500',
    'https://m.media-amazon.com/images/I/313dtY-LOEL.jpg',
    'https://m.media-amazon.com/images/I/61M7ZbTTlVL.jpg',
    'https://www.freshaisle.com/cdn/shop/products/fresh-button-mushroom-200-gm-mushrooms-901.jpg?v=1681470067',
    'https://chefsmandala.com/wp-content/uploads/2018/03/Onion-Red.jpg',
    'https://veggies.my/cdn/shop/products/carrot.jpg?v=1588226706',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vegetables List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ));
              },
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 2)),
                child: const Icon(Icons.shopping_bag_sharp),
              ),
            ),
          ),
          //const SizedBox(width: 15,),
        ],
        backgroundColor: Colors.blue,
        foregroundColor: const Color.fromARGB(255, 239, 238, 238),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              height: 100,
                              width: 100,
                              image:
                                  NetworkImage(productImage[index].toString()),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName[index].toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Kg ${productPrice[index]}/-',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DetailsScreen()));
                                    },
                                    child: const  Text('Click here for details', 
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        )),
                                  ),
                                ],
                              ),
                            ),

                            //Text(index.toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  dbHelper!
                                      .insert(Cart(
                                          id: index,
                                          productId: index.toString(),
                                          productName:
                                              productName[index].toString(),
                                          productPrice: productPrice[index],
                                          initialPrice: productPrice[index],
                                          quantity: 1,
                                          unitTag:
                                              productName[index].toString(),
                                          image:
                                              productImage[index].toString()))
                                      .then(
                                    (value) {
                                      print('Product is added to cart');
                                      cart.addTotalPrice(double.parse(
                                          productPrice[index].toString()));
                                      cart.addCounter();
                                    },
                                  ).onError(
                                    (error, stackTrace) {
                                      print(error);
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white),
                                icon: const Icon(Icons.add),
                                label: const Text('Add'))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
