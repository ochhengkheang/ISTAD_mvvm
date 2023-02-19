import 'package:flutter_mvvm_provider/data/network/network_api_service.dart';
import 'package:flutter_mvvm_provider/models/image_response.dart';
import 'package:flutter_mvvm_provider/models/product.dart';
import 'package:flutter_mvvm_provider/models/product_request.dart';
import 'package:flutter_mvvm_provider/models/product_response.dart';
import 'package:flutter_mvvm_provider/res/app_url.dart';

class ProductRepository {
  final _apiService = NetworkApiService();

  Future postProduct(dataRequest) async {
    try {
      var data = ProductRequest(data: dataRequest);
      var product = ProductRequest(data: dataRequest);
      var response =
          await _apiService.putApi(AppUrl.products, product.toJson());
      return response = ProductResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future putProduct(dataRequest, id) async {
    //add parameter id to receive id to put post api url end point
    try {
      var data = ProductRequest(data: dataRequest);
      var product = ProductRequest(data: dataRequest);
      var response =
          await _apiService.postApi('${AppUrl.products}/$id', product.toJson());
      return response = ProductResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ImageResponse> uploadImage(file) async {
    try {
      var response = await _apiService.uploadImage(AppUrl.uploadImage, file);
      return response = ImageResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getProducts(page, limit) async {
    try {
      var url =
          '${AppUrl.products}&pagination%5Bpage%5D=$page&pagination%5BpageSize%5D=$limit';
      print('url $url');
      dynamic response = await _apiService.getApiResponse(url);
      return response = ProductModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }
}
