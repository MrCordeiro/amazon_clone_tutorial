import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/features/account/widgets/single_product.dart';
import "package:flutter/material.dart";

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List list = GlobalVariables.carouselImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 15),
                child: const Text(
                  "Your Orders",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  "See all",
                  style: TextStyle(color: GlobalVariables.selectedNavBarColor),
                )),
          ],
        ),
        // Display past orders
        Container(
          height: 170,
          padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: ((context, index) {
                return SingleProduct(
                  image: list[index],
                );
              })
              ),
        )
      ],
    );
  }
}
