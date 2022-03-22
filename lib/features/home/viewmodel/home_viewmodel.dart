import 'package:provider/provider.dart';
import 'package:ui_challenge_1/core/base_viewmodel.dart';
import 'package:ui_challenge_1/features/basket/viewmodel/basket_viewmodel.dart';
import 'package:ui_challenge_1/model/product.dart';

class HomeViewModel extends BaseViewModel {
  List<Product> products = [];

  Product? selectedProduct;

  init() {
    products = Product.mockListProduct;
  }

  addProduct(Product product) async {
    selectedProduct = product;
    notifyListeners();

    await getProvider<BasketViewModel>().addProduct(product);

    selectedProduct = null;
      notifyListeners();
  }
}
