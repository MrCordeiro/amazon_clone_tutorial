import 'package:amazon_clone_tutorial/common/widgets/custom_button.dart';
import 'package:amazon_clone_tutorial/common/widgets/stars.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/features/product_detail/services/product_detail_services.dart';
import 'package:amazon_clone_tutorial/features/search/screens/search_screen.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-detail';
  final Product product;
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailServices _productDetailServices = ProductDetailServices();
  double avgRating = 0;
  double userRating = 0;

  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (var rating in widget.product.rating!) {
      totalRating += rating.rating;
      if(rating.userId == Provider.of<UserProvider>(context, listen: false).user.id) {
        userRating = rating.rating;
      }
    }
    if (totalRating > 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    _productDetailServices.addToCart(context: context, product: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(Icons.search,
                                  color: Colors.black, size: 23),
                            )),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.black38, width: 1),
                        ),
                        hintText: "Search Amazon.com",
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(Icons.mic, color: Colors.black, size: 25))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.product.id!),
                Stars(rating: avgRating),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                widget.product.name,
                style: const TextStyle(fontSize: 15),
              )),
          CarouselSlider(
            items: widget.product.images.map(
              (i) {
                return Builder(
                  builder: (BuildContext context) => Image.network(
                    i,
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                );
              },
            ).toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              height: 300,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: RichText(
                text: TextSpan(
                    text: "Deal Price: ",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                    text: "\$${widget.product.price}",
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  )
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.product.description),
          ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomButton(text: "Buy now", onTap: () {}),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomButton(
              text: "Add to Cart",
              onTap: addToCart,
              color: const Color.fromRGBO(254, 216, 19, 1),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          const SizedBox(height: 10),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Rate the product",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
          RatingBar.builder(
              initialRating: userRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: GlobalVariables.primaryColor,
                  ),
              onRatingUpdate: (rating) {
                _productDetailServices.rateProduct(
                    context: context, product: widget.product, rating: rating);
              })
        ]),
      ),
    );
  }
}


// Next step: Rating products