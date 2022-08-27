import 'package:amazon_clone_tutorial/common/widgets/loader.dart';
import 'package:amazon_clone_tutorial/features/account/widgets/single_product.dart';
import 'package:amazon_clone_tutorial/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone_tutorial/features/admin/services/admin_services.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import "package:flutter/material.dart";

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminServices _adminServices = AdminServices();
  List<Product>? _products = [];

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  // We can't use fetchAllProducts() in initState() because you can't call async functions in initState.
  // So we will create this helper function to call fetchAllProducts().
  fetchAllProducts() async {
    _products = await _adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return _products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
                itemCount: _products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final productData = _products![index];
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 140,
                          child: SingleProduct(image: productData.images[0]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Text(productData.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete_outline)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              tooltip: "Add a new product",
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
