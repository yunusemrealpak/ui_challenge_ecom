import 'package:ui_challenge_1/core/base_viewmodel.dart';
import 'package:ui_challenge_1/model/product.dart';

class BasketViewModel extends BaseViewModel {
  List<Product> products = [];
  List<Product> showMiniCardProducts = [];

  bool showCart = false;
  bool hasCard = false;

  Future addProduct(Product product) async {
    await Future.delayed(const Duration(seconds: 3));

    if (hasCard) {
      showCart = false;
    } else {
      hasCard = true;
    }

    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 350));
    products.add(product);
    if(showMiniCardProducts.length<3) showMiniCardProducts.add(product);
    await Future.delayed(const Duration(milliseconds: 100));

    showCart = true;
    notifyListeners();
  }
}
