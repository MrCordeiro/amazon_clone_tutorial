import 'package:amazon_clone_tutorial/common/widgets/loader.dart';
import 'package:amazon_clone_tutorial/features/home/services/home_services.dart';
import 'package:amazon_clone_tutorial/features/product_detail/screens/product_detail_screen.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import "package:flutter/material.dart";

class DealOfDay extends StatefulWidget {
  const DealOfDay({Key? key}) : super(key: key);

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? product;
  final HomeServices _homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product = await _homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Loader()
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetailScreen.routeName,
                    arguments: product,
                  );
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: const Text(
                        "Deal of the day",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    // Product Image
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product!.images[0],
                          height: 235,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    // Product Price
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        '\$100',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    // Product Name
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: Text(
                        product!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Other images of the same Product
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: product!.images
                            .map(
                              (e) => Image.network(e,
                                  fit: BoxFit.fitWidth,
                                  height: 100,
                                  width: 100),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ).copyWith(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'See all deals',
                        style: TextStyle(
                          color: Colors.cyan[800],
                        ),
                      ),
                    )
                  ],
                ),
              );
  }
}
