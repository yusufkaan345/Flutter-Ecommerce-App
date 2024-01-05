import 'package:dio/dio.dart';
import 'package:ecommerce/app-color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  final String productName;
  final String imageUrl;
  final String productPrice;
 final String productFeatures;
 final String productStar;
final String productCategory;
  ProductDetails({
    Key? key,
    required this.productName,
    required this.imageUrl,
    required this.productPrice,
    required this.productFeatures,
    required this.productStar,
    required this. productCategory
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
   void addToBasket(BuildContext context) async {
    try {
      final Dio dio = Dio();
      final response =
          await dio.post('http://localhost:5280/api/Basket', data: {
        "productName": widget.productName,
        "productCategory": widget.productCategory,
        "productImgUrl": widget.imageUrl,
        "productFeatures":widget. productFeatures,
        "productPrice": int.parse(widget.productPrice),
        "productStar": int.parse(widget.productStar),
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName), // Ürün adını başlık olarak göster
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width * (0.8),
              height: size.height * (0.35),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                height: size.height * (0.40),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        widget.productName,
                        style: TextStyle(
                          fontSize: 24, // Örneğin, font size'ı 24 yapabilirsiniz
                          fontWeight: FontWeight.bold, // Kalın yazı
                        ),
                      ),
                    ),
                    Text(
                      widget.productPrice,
                      style: TextStyle(
                        fontSize: 20, // Örneğin, font size'ı 20 yapabilirsiniz
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      "Ürün Özellikleri",
                      style: TextStyle(
                        fontSize: 20, // Örneğin, font size'ı 18 yapabilirsiniz
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: Text(
                       widget.productFeatures,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16, // Örneğin, font size'ı 16 yapabilirsiniz
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}