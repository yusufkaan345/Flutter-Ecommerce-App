import 'package:dio/dio.dart';
import 'package:ecommerce/app-color.dart';
import 'package:ecommerce/product-details.dart';
import 'package:ecommerce/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryList extends StatefulWidget {
  final String categoryName;
  final List<Product> categoryProducts;

  CategoryList({required this.categoryName, required this.categoryProducts});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Product> filteredProducts = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchProducts(''); // Başlangıçta varsayılan bir filtreleme yapılıyor
  }

  void searchProducts(String query) {
    setState(() {
       if (query.isNotEmpty) {
        // Arama sorgusuna uygun ürünleri filtrele
        filteredProducts = widget.categoryProducts
            .where((product) => product.productName!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      } else {
        // Arama sorgusu boş ise tüm ürünleri göster
        filteredProducts = widget.categoryProducts;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onChanged: (query) {
                searchProducts(_controller.text);
              },
              decoration: InputDecoration(
                hintText: 'Ürün Ara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (filteredProducts.length / 2).ceil(),
              itemBuilder: (context, index) {
                final firstProduct = filteredProducts[index * 2];
                final secondProduct =
                    (index * 2 + 1 < filteredProducts.length)
                        ? filteredProducts[index * 2 + 1]
                        : null;

                if (secondProduct != null) {
                  return Row(
                    children: [
                      Expanded(
                        child: ProductCard(
                          productName: firstProduct.productName.toString(),
                          productCategory:firstProduct.productCategory.toString(),
                          imageURL: firstProduct.productImgUrl.toString(),
                          productFeatures:firstProduct.productFeatures.toString(),
                          productPrice: firstProduct.productPrice.toString(),
                          productStar: firstProduct.productStar.toString(),
                        ),
                      ),
                      Expanded(
                        child: ProductCard(
                          productName: secondProduct.productName.toString(),
                          productCategory:secondProduct.productCategory.toString(),
                          imageURL: secondProduct.productImgUrl.toString(),
                          productFeatures:secondProduct.productFeatures.toString(),
                          productPrice: secondProduct.productPrice.toString(),
                          productStar: secondProduct.productStar.toString(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: ProductCard(
                          productName: firstProduct.productName.toString(),
                          productCategory:firstProduct.productCategory.toString(),
                          imageURL: firstProduct.productImgUrl.toString(),
                          productFeatures:firstProduct.productFeatures.toString(),
                          productPrice: firstProduct.productPrice.toString(),
                          productStar: firstProduct.productStar.toString(),
                        ),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String productCategory;
  final String imageURL;
  final String productFeatures;
  final String productPrice;
  final String productStar;

  ProductCard({
    required this.productName,
    required this.productCategory,
    required this.imageURL,
    required this.productFeatures,
    required this.productPrice,
    required this.productStar,
  });
  void addToBasket(BuildContext context) async {
    try {
      final Dio dio = Dio();
      final response =
          await dio.post('http://localhost:5280/api/Basket', data: {
        "productName": productName,
        "productCategory": productCategory,
        "productImgUrl": imageURL,
        "productFeatures": productFeatures,
        "productPrice": int.parse(productPrice),
        "productStar": int.parse(productStar),
      });

      // İstek başarılıysa
      if (response.statusCode == 200) {
        print('Ürün sepete eklendi.');

        // Show toast message
        Fluttertoast.showToast(
          msg: 'Ürün başarıyla Sepetinize eklendi',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Hata durumunda
        print('Ürün eklenirken bir hata oluştu.');
      }
    } catch (e) {
      // Hata durumunda
      print('Ürün eklenirken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetails(
                productName: productName,
                imageUrl: imageURL,
                productPrice: productPrice,
                productFeatures:productFeatures,
                productCategory:productCategory,
                productStar:productStar,

                ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.black, width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageURL),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productName,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                 '\$ $productPrice',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  addToBasket(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grannyApple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Sepete Ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
