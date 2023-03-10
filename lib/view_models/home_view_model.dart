import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm_provider/data/response/api_response.dart';
import 'package:flutter_mvvm_provider/models/image_response.dart';
import 'package:flutter_mvvm_provider/models/product.dart';
import 'package:flutter_mvvm_provider/models/product_request.dart';
import 'package:flutter_mvvm_provider/models/product_response.dart';
import 'package:flutter_mvvm_provider/repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final _productRepository = ProductRepository();

  ApiResponse<ProductModel> apiResponse = ApiResponse.loading();
  ApiResponse<ProductResponse> productResponse = ApiResponse.loading();

  setProductResponse(ApiResponse<ProductResponse> response) {
    productResponse = response;
    notifyListeners();
  }

  setProductList(ApiResponse<ProductModel> response) {
    apiResponse = response;
    notifyListeners();
  }

  Future postProduct(dataRequest) async {
    await _productRepository
        .postProduct(dataRequest)
        .then((value) => {setProductResponse(ApiResponse.complete(value))})
        .onError((error, stackTrace) =>
            {setProductResponse(ApiResponse.error(error.toString()))});
    print('Post success');
  }

  Future putProduct(dataRequest, id) async {
    await _productRepository
        .putProduct(dataRequest, id)
        .then((value) => {setProductResponse(ApiResponse.complete(value))})
        .onError((error, stackTrace) =>
            {setProductResponse(ApiResponse.error(error.toString()))});
    print('Put success');
  }

  Future<dynamic> getProducts(page, limit) async {
    // setProductList(ApiResponse.loading());
    await _productRepository.getProducts(page, limit).then((productList) {
      print('success');
      setProductList(ApiResponse.complete(productList));
    }).onError((error, stackTrace) {
      print('error ${error.toString()}');
      setProductList(ApiResponse.error(error.toString()));
    });
  }
}
