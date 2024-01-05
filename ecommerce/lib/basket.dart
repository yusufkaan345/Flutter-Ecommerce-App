// ignore_for_file: prefer_const_constructors
import 'package:dio/dio.dart';
import 'package:ecommerce/app-color.dart';
import 'package:ecommerce/categories.dart';
import 'package:ecommerce/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Eklenen kısım
import 'package:ecommerce/product.dart';

class Basket extends StatefulWidget {
  final List<Product> products;
  const Basket({super.key, required this.products});

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  List<Product> baskets = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final Dio dio = Dio();
    try {
      var response = await dio.get('http://localhost:5280/api/Basket');

      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          baskets = data(response.data);
        });
        print(baskets[0].productName);
      } else {
        // Handle error state
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("olmaadı  :()");
      print(e);
    }
  }

  List<Product> data(dynamic responseData) {
    List<dynamic> jsonList = responseData;
    List<Product> baskets =
        jsonList.map((json) => Product.fromJson(json)).toList();
    return baskets;
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else if (_selectedIndex == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Categories(products: widget.products),
        ),
      );
    }
  }

  void onDeletePressed(String productId) async {
    final Dio dio = Dio();
    try {
      var response =
          await dio.delete('http://localhost:5280/api/Basket/$productId');

      print(response.statusCode);

      if (response.statusCode == 200) {
        // Başarıyla silindi
        print('Product with productId: $productId deleted successfully');

        // TODO: İsterseniz setState ile yeniden liste güncellenir.
        setState(() {
          baskets.removeWhere((product) => product.productId == productId);
        });

        // Toast mesajı gösterme
        Fluttertoast.showToast(
          msg: 'Ürün başarıyla silindi',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.deepOrange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Basket(products: widget.products),
          ),
        );
      } else {
        // Handle error state
        print('Failed to delete product with productId: $productId');
      }
    } catch (e) {
      print("Hata oluştu :()");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sepet"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * (0.65),
            child: ListView.builder(
              itemCount: baskets.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  itemName: baskets[index].productName.toString(),
                  itemPrice: baskets[index].productPrice.toString(),
                  imgSrc: baskets[index].productImgUrl.toString(),
                  productId: baskets[index].productId.toString(),
                  onDeletePressed: onDeletePressed,
                );
              },
            ),
          ),
          ConfirmPurchase(
            baskets: baskets,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Basket',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imgSrc,
    required this.productId,
    required this.onDeletePressed, // Eklenen kısım
  }) : super(key: key);

  final String itemName;
  final String itemPrice;
  final String imgSrc;
  final String productId;
  final Function(String) onDeletePressed; // Eklenen kısım

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 200,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.black, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.network(
                  imgSrc,
                  width: 200,
                  height: 150,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(itemName),
                  Text(itemPrice),
                  ElevatedButton(
                    onPressed: () {
                      onDeletePressed(
                          productId); // onDeletePressed fonksiyonunu çağırın
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmPurchase extends StatelessWidget {
  final List<Product> baskets;

  ConfirmPurchase({required this.baskets});

  @override
  Widget build(BuildContext context) {
    // Calculate the total amount by summing up product prices
    double totalAmount = baskets.fold(
        0, (sum, product) => sum + product.productPrice!.toDouble());

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      margin: EdgeInsets.only(top: 40),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Column(
               
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    
                    child: Text(
                      "${totalAmount.toStringAsFixed(2)} ₺", // Format total amount to display with 2 decimal places
                      style: TextStyle(color: Colors.orange, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: AppColors.grannyApple,
                    child: Text(
                      "Alışverişi Tamamla",
                      style: TextStyle(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
