import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_challenge_1/core/base_viewmodel.dart';
import 'package:ui_challenge_1/model/size.dart';

import '../../../model/product.dart';

class ProductDetailsViewModel extends BaseViewModel {
  List<Size> sizes = List.generate(6, (index) => Size(id: index+1, size: "US ${index+6}"));
  List<Color> colors = [Colors.black, Colors.white, Colors.red];

  Size? selectedSize;
  Color? selectedColor;

  init() {
    selectedSize = sizes.first;
    notifyListeners();
  }

  setSize(Size size) {
    selectedSize = size;
    notifyListeners();
  }

  setColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  addToCart(Product prod) {
    Navigator.of(context!).pop(prod);
  }
}