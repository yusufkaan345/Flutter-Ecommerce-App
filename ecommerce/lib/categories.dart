import 'package:ecommerce/basket.dart';
import 'package:ecommerce/category-list.dart';
import 'package:ecommerce/home.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/product.dart';

class Categories extends StatefulWidget {
  final List<Product> products;
  const Categories({super.key, required this.products});
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _selectedIndex = 1; // Başlangıçta seçili olan öğe (Categories sayfası)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      // 0. indekse tıklandığında Home sayfasına git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else if (_selectedIndex == 2) {
      // 2. indekse tıklandığında diğer sayfaya git
      // Örneğin, Basket sayfasına gitmek için
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Basket(products: widget.products),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CategoryInfo> kategoriler = [
      CategoryInfo('Teknoloji',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvMQ_IoM1XBfv63HKeJ6FeU6eq53_4V0cITA&usqp=CAU'),
      CategoryInfo('Moda',
          'https://w7.pngwing.com/pngs/170/879/png-transparent-clothing-fashion-dress-woman-creative-fashion-icon-fashion-monochrome-fictional-character-thumbnail.png'),
      CategoryInfo('Aksesuar',
          'https://w7.pngwing.com/pngs/646/532/png-transparent-necklace-necklace-fashion-chain-fashion-accessory.png'),
      CategoryInfo('Ev',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzE-RKysm3FnJxYMbKuxves9fnOHLmE28Vxw&usqp=CAU'),
      CategoryInfo('Ciltbakım',
          'https://www.bbstasarim.com.tr/uploads-165437-150ml-cam-buzlu-losyon-%C5%9Fi%C5%9Fesi-do%C4%9Fal-ah%C5%9Fap-bambu-4-img.jpg'),
      CategoryInfo('Spor',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPA9E9FJGpXISokrAISatFMOg6lZrnlmjM2w&usqp=CAU'),
      CategoryInfo('Beyaz Eşya',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-_kvIkwuhHPDVe5cfm9PUDQFNlokivKAA7g&usqp=CAU'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: ListView.builder(
        itemCount: kategoriler.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (widget.products.isNotEmpty) {
                List<Product> categoryProducts = widget.products
                    .where((product) =>
                        product.productCategory == kategoriler[index].name)
                    .toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryList(
                      categoryName: kategoriler[index].name,
                      categoryProducts: categoryProducts,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: 80,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Sol tarafta resim
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(kategoriler[index].imageUrl,scale: 1),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Sağ tarafta kategori ismi
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          kategoriler[index].name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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

class CategoryInfo {
  final String name;
  final String imageUrl;

  CategoryInfo(this.name, this.imageUrl);
}