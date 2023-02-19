import 'package:flutter/material.dart';
import 'package:flutter_mvvm_provider/views/add_product/add_screen.dart';

import '../../../models/product.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.product,
    required this.id,
  });

  final Attributes? product;
  var id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //when click on listtitle, go to productScreen
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddProductScreen(
                    product: product, isUpdate: true, id: id)));
      },
      title: Text('${product?.title}'),
      subtitle: Text('${product?.price}'),
      leading: product?.thumbnail?.data == null
          ? CircularProgressIndicator()
          : Image.network(
              'https://cms.istad.co${product?.thumbnail?.data?.attributes?.url}'),
    );
  }
}
