import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_cart/models/products.dart';
import 'package:vegetables_cart/provider.dart/cart_provider.dart';
import 'package:vegetables_cart/data_base.dart';
import 'package:badges/badges.dart' as badges;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
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
          //const SizedBox(width: 15,),
        ],
        backgroundColor: Colors.blue,
        foregroundColor: const Color.fromARGB(255, 239, 238, 238),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {

                if(snapshot.data!.isEmpty){
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(100, 120, 0,0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('image/emptycart.jpg')),
                         SizedBox(height: 10,),
                         Text('Cart is empty'),
                      ],
                    ),
                  );
                }else{
                  return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
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
                                    image: NetworkImage(
                                        snapshot.data![index].image.toString()),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].productName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Kg ${snapshot.data![index].productPrice.toString()}/-',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //Text(index.toString()),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            dbHelper!.delete(
                                                snapshot.data![index].id!);
                                            cart.removeCounter();
                                            cart.removeTotalPrice(double.parse(
                                                snapshot
                                                    .data![index].productPrice
                                                    .toString()));
                                          },
                                          child: const Icon(Icons.delete)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(  
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                int quantity = snapshot.data![index].quantity!;
                                                int price = snapshot.data![index].initialPrice!;
                                                quantity--;
                                                int? newPrice = price * quantity;

                                                if (quantity > 0){
                                                  dbHelper!.updateQuantity(
                                                  Cart(
                                                    id: snapshot.data![index].id!, 
                                                    productId: snapshot.data![index].id!.toString(),
                                                    productName: snapshot.data![index].productName!, 
                                                    productPrice: newPrice,
                                                    initialPrice: snapshot.data![index].initialPrice!,
                                                    quantity: quantity, 
                                                    unitTag: snapshot.data![index].unitTag.toString(),
                                                    image: snapshot.data![index].image.toString()
                                                    ),
                                                ).then((value){
                                                  newPrice =0;
                                                  quantity=0;
                                                  cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                }).onError((error, stackTrace) {
                                                  print(error.toString());
                                                },);

                                                }

                                                
                                              },
                                              child: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                                snapshot.data![index].quantity
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            InkWell(
                                              onTap: () {
                                                int quantity = snapshot.data![index].quantity!;
                                                int price = snapshot.data![index].initialPrice!;
                                                quantity++;
                                                int? newPrice = price * quantity;

                                                dbHelper!.updateQuantity(
                                                  Cart(
                                                    id: snapshot.data![index].id!, 
                                                    productId: snapshot.data![index].id!.toString(),
                                                    productName: snapshot.data![index].productName!, 
                                                    productPrice: newPrice,
                                                    initialPrice: snapshot.data![index].initialPrice!,
                                                    quantity: quantity, 
                                                    unitTag: snapshot.data![index].unitTag.toString(),
                                                    image: snapshot.data![index].image.toString()
                                                    ),

                                                ).then((value){
                                                  newPrice =0;
                                                  quantity=0;
                                                  cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                }).onError((error, stackTrace) {
                                                  print(error.toString());
                                                },);
                                              },
                                              child: const Icon(Icons.add,color: Colors.white,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
                }
              }
              return Text('');
            },
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
                child: Column(
                  children: [
                    ReusableWidget(
                        title: 'Total : ', value: r'$'+ value.getTotalPrice().toStringAsFixed(2),),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  const ReusableWidget({super.key, required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
