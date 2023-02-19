import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm_provider/data/response/status.dart';
import 'package:flutter_mvvm_provider/models/product.dart';
import 'package:flutter_mvvm_provider/models/product_request.dart';
import 'package:flutter_mvvm_provider/view_models/home_view_model.dart';
import 'package:flutter_mvvm_provider/view_models/image_view.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key? key, this.product, this.isUpdate = false, this.id})
      : super(key: key);

  Attributes? product;
  var isUpdate;
  var id;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var homeViewModel = HomeViewModel();
  var imageViewModel = ImageViewModel();
  var imageFile;
  var titleController = TextEditingController();
  var ratingController = TextEditingController();
  var descriptionController = TextEditingController();
  var quantityController = TextEditingController();
  var priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      titleController.text = widget.product!.title!;
      ratingController.text = widget.product!.rating!;
      quantityController.text = widget.product!.quantity!;
      descriptionController.text = widget.product!.description!;
      priceController.text = widget.product!.price!;
    }
  }

  _getImageFromGalleryOrCamera(String type) async {
    print('type $type');
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: type == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
      imageViewModel.uploadImage(pickedFile.path);
    } else
      print('image not picked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _getImageFromGalleryOrCamera('camera');
                },
                icon: const Icon(Icons.camera)),
            IconButton(
                onPressed: () {
                  _getImageFromGalleryOrCamera('gallery');
                },
                icon: const Icon(Icons.browse_gallery)),
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ChangeNotifierProvider<HomeViewModel>(
                  create: (BuildContext ctx) => homeViewModel,
                  child: Consumer(builder: (ctx, image, _) {
                    //get product response status
                    if (homeViewModel.productResponse.status ==
                        Status.COMPLETED) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Post product Success')));
                      });
                    }

                    /*double notify listener because they are called in the same notifer in the view model
                      consider create diffrent repo (homeviewmodel and imageview model) and call different notifier
                    */
                    // print('image url ${homeViewModel.imageResponse.data!.url}');
                    return Center(
                      child: imageFile == null
                          ? Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/681px-Placeholder_view_vector.svg.png',
                              width: 150,
                              height: 150)
                          : Image.file(imageFile,
                              fit: BoxFit.cover, width: 150, height: 150),
                    );
                  }),
                ),
                ChangeNotifierProvider<ImageViewModel>(
                  create: (BuildContext ctx) => imageViewModel,
                  child: Consumer(builder: (ctx, image, _) {
                    /*double notify listener because they are called in the same notifer in the view model
                      consider create diffrent repo (homeviewmodel and imageview model) and call different notifier
                    */
                    if (imageViewModel.imageResponse.status ==
                        Status.COMPLETED) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Upload image Success')));
                      });
                    }

                    // print('image url ${homeViewModel.imageResponse.data!.url}');
                    return Center(
                      child: imageFile == null
                          ? Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/681px-Placeholder_view_vector.svg.png',
                              width: 150,
                              height: 150)
                          : Image.file(imageFile,
                              fit: BoxFit.cover, width: 150, height: 150),
                    );
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Title')),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: ratingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Rating')),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Description'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Quantity')),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Price')),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      var thumbnaiId = imageViewModel
                          .imageResponse.data!.id; //getthumbnailid
                      var dataRequest = DataRequest(
                          title: titleController.text,
                          rating: ratingController.text,
                          description: descriptionController.text,
                          category: '1',
                          thumbnail: thumbnaiId.toString(),
                          quantity: quantityController.text,
                          price: priceController.text);
                      print("Is update" + widget.isUpdate);
                      print("Hello " + widget.id);
                      if (widget.isUpdate) {
                        // check for post or put
                        homeViewModel.putProduct(dataRequest, widget.id);
                      } else
                        homeViewModel.postProduct(dataRequest);
                    },
                    child: widget.isUpdate ? Text('Update') : Text('Post'))
              ],
            ),
          ),
        ));
  }
}
