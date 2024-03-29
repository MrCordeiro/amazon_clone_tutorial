import 'package:amazon_clone_tutorial/common/widgets/stars.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import "package:flutter/material.dart";

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double avgRating = 0;
    double totalRating = 0;
    for (var rating in product.rating!) {
      totalRating += rating.rating;
    }
    if (totalRating > 0) {
      avgRating = totalRating / product.rating!.length;
    }
  
    return Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            // Image
            Image.network(
              product.images[0],
              fit: BoxFit.contain,
              height: 135,
              width: 135,
            ),

            Column(
              children: [

                // Product name 
                Container(
                  width: 235,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                  ),
                ),

                // Ratings
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Stars(rating: avgRating),
                ),

                // Free shipping
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text('Eligible for FREE Shipping'),
                ),

                // Price
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
              
                // Availability
                Container(
                  width: 235,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: const Text(
                    'In Stock',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                    maxLines: 2,
                  ),
                )
              ],
            )
          ]
        ),
      )
    ]);
  }
}
