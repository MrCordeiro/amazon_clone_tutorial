import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/models/product.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdminServices {
  void addProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Upload image file to Cloudinary
      final cloudinary = CloudinaryPublic(
        dotenv.get('CLOUDINARY_CLOUD_NAME'), // taken from cloudinary dashboard
        dotenv.get(
            'CLOUDINARY_UPLOAD_PRESET'), // taken from cloudinary setting "enable unsigned upload" option
      );
      List<String> imageUrls = [];
      for (var image in images) {
        await cloudinary
            .uploadFile(CloudinaryFile.fromFile(image.path,
                folder: name, resourceType: CloudinaryResourceType.Image))
            .then((value) {
          imageUrls.add(value.secureUrl);
        });
      }

      // Upload product info to MongoDB
      Product product = Product(
          name: name,
          description: description,
          price: price,
          quantity: quantity,
          images: imageUrls,
          category: category);

      http.Response res = await http.post(
        Uri.parse('$uri/admin/products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(Uri.parse('$uri/admin/products'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (var product in jsonDecode(res.body)) {
            productList.add(Product.fromJson(jsonEncode(product)));
          }
        },
      );
  
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}
