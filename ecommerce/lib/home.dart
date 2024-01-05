// ignore_for_file: sort_child_properties_last

import 'package:dio/dio.dart';
import 'package:ecommerce/basket.dart';
import 'package:ecommerce/categories.dart';
import 'package:ecommerce/category-list.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final Dio dio = Dio();
    try {
      var response = await dio.get('http://localhost:5280/api/Product');

      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          products = data(response.data);
          print("status kodu 200");
        });
        print(products[0].productName);
      } else {
        // Handle error state
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("olmaadı  :(");
      print(e);
    }
  }

  void _onCategoryTapped(String categoryName) {
    List<Product> categoryProducts = products
        .where((product) => product.productCategory == categoryName)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryList(
          categoryName: categoryName,
          categoryProducts: categoryProducts,
        ),
      ),
    );
  }

  List<Product> data(dynamic responseData) {
    List<dynamic> jsonList = responseData;
    List<Product> products =
        jsonList.map((json) => Product.fromJson(json)).toList();
    return products;
  }

  int _selectedIndex = 0; // Başlangıçta seçili olan öğe (Categories sayfası)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      // 0. indekse tıklandığında Home sayfasına git
      print(_selectedIndex);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Categories(
            products: products,
          ),
        ),
      );
    } else if (_selectedIndex == 2) {
      // 2. indekse tıklandığında diğer sayfaya git
      // Örneğin, Basket sayfasına gitmek için
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Basket(products: products),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                _onCategoryTapped("Ev");
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        'https://static.vecteezy.com/system/resources/previews/015/274/894/large_2x/empty-horizontal-picture-frame-on-white-brick-wall-in-modern-living-room-mock-up-interior-in-minimalist-contemporary-style-free-space-for-your-picture-poster-wooden-table-vase-3d-rendering-photo.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      child: Text(
                        "Ev Ürünlerinde %50 İndirimi Kaçırma ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _onCategoryTapped("Teknoloji");
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1nRHVOJrJWWU58YNjDTk9zKbMRtRbfHdhZw&usqp=CAU',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _onCategoryTapped("Moda");
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        'https://media.licdn.com/dms/image/C4D12AQFQpt2rm6Eu2A/article-cover_image-shrink_720_1280/0/1573420320849?e=2147483647&v=beta&t=C6kpfU8fVoXYzSDEQpfybi1enDRff1aRRhQNxFJWXUY',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      child: Text(
                        "Yeni Sezon ",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            flex: 1,
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
