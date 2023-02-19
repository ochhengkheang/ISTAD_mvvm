import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm_provider/data/response/api_response.dart';
import 'package:flutter_mvvm_provider/models/image_response.dart';
import 'package:flutter_mvvm_provider/repository/home_repository.dart';

class ImageViewModel extends ChangeNotifier {
  final _productRepository = ProductRepository();

  ApiResponse<ImageResponse> imageResponse = ApiResponse.loading();

  setImageResponse(ApiResponse<ImageResponse> response) {
    imageResponse = response;
    notifyListeners();
  }

  Future<dynamic> uploadImage(file) async {
    await _productRepository
        .uploadImage(file)
        .then((image) => {setImageResponse(ApiResponse.complete(image))})
        .onError((error, stackTrace) =>
            {setImageResponse(ApiResponse.error(error.toString()))});
  }
}
