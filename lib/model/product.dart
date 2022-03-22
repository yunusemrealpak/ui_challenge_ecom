import 'dart:math';

class Product {
  int id;
  String model;
  String brand;
  double price;
  String image;
  Product({
    required this.id,
    required this.model,
    required this.brand,
    required this.price,
    required this.image,
  });

  static List<Product> get mockListProduct {
    Random random = Random();
    List<Product> products = [];

    final nikeList = List.generate(5, (index) => Product(
      id: (index+1) * 10,
      brand: "Nike",
      image: "im_nike_${index+1}",
      model: "Model ${index+1}",
      price: random.nextInt(900) + 150,
    ));
    products.addAll(nikeList);

    final adidasList = List.generate(2, (index) => Product(
      id: (index+1) * 20,
      brand: "Adidas",
      image: "im_adidas_${index+1}",
      model: "Model ${index+1}",
      price: random.nextInt(750) + 125,
    ));
    products.addAll(adidasList);

    return products;
  }
}
