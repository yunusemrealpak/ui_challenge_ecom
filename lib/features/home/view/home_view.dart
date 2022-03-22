// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge_1/core/base_provider.dart';
import 'package:ui_challenge_1/core/extensions/context_extensions.dart';
import 'package:ui_challenge_1/core/extensions/string_extensions.dart';
import 'package:ui_challenge_1/features/home/viewmodel/home_viewmodel.dart';
import 'package:ui_challenge_1/features/home/widgets/basket_area.dart';
import 'package:ui_challenge_1/model/product.dart';

import '../../../core/helper/my_scroll_behaviour.dart';
import '../../basket/viewmodel/basket_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel viewModel;

  int value = 0;
  bool showAppbarTitle = false;

  late ScrollController _scrollController;
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.position.pixels > 50) {
      if (showAppbarTitle) return;
      setState(() {
        showAppbarTitle = true;
      });
    } else {
      if (!showAppbarTitle) return;
      setState(() {
        showAppbarTitle = false;
      });
    }
  }

  addProduct(Product product) async {
    viewModel.addProduct(product);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (model) {
        viewModel = model;
        model.setContext(context);
        model.init();
      },
      builder: (context, model, _) => Scaffold(
        appBar: buildAppBar(),
        body: Stack(
          children: [
            SafeArea(
              child: ScrollConfiguration(
                behavior: MyScrollBehavior(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Catalog",
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: buildFilterArea(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                            ),
                            itemCount: model.products.length,
                            itemBuilder: (context, index) {
                              var prod = model.products.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("details", arguments: prod)
                                        .then((value) {
                                      if (value != null) {
                                        model.addProduct(value as Product);
                                      }
                                    });
                                  },
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(Icons.heart_broken,
                                                    color: Colors.grey),
                                                model.selectedProduct?.id ==
                                                        prod.id
                                                    ? Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SizedBox(
                                                          width: 35,
                                                          height: 35,
                                                          child:
                                                              SpinKitSpinningLines(
                                                            color:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                            size: 50.0,
                                                          ),
                                                        ),
                                                    )
                                                    : IconButton(
                                                        onPressed: () => model
                                                            .addProduct(prod),
                                                        icon: Icon(
                                                          Icons.add,
                                                          size: 30,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Image.asset(
                                              prod.image.toPng,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Column(
                                            children: [
                                              Text(
                                                prod.brand,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                              Text(
                                                prod.model,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "\$${prod.price}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFFf58d15),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (model.getProvider<BasketViewModel>().hasCard)
                          SizedBox(
                            height: 150,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            buildCart(model, context),
          ],
        ),
      ),
    );
  }

  Widget buildCart(HomeViewModel model, BuildContext context) {
    return Consumer<BasketViewModel>(
      builder: (context, basketModel, _) => AnimatedPositioned(
        duration: Duration(milliseconds: 350),
        left: 0,
        right: 0,
        bottom: basketModel.hasCard ? 0 : -100,
        curve: Curves.easeOut,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("basket");
          },
          child: ClipPath(
            clipper: CardClipper(),
            child: Container(
              height: context.customHeightValue(0.2),
              width: double.infinity,
              color: Colors.black,
              padding: EdgeInsets.only(top: 75, left: 25, right: 25),
              child: AnimatedOpacity(
                opacity: basketModel.showCart ? 1 : 0,
                duration: const Duration(milliseconds: 350),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "title",
                      child: SizedBox(
                        width: context.customWidthValue(0.25),
                        child: const Text(
                          "Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: basketModel.showMiniCardProducts.map(
                            (p) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.asset(p.image.toPng),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        if (basketModel.products.length > 3)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: CircleAvatar(
          backgroundColor: Colors.cyan,
        ),
      ),
      title: AnimatedOpacity(
        opacity: showAppbarTitle ? 1 : 0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: AnimatedPadding(
          padding: EdgeInsets.only(bottom: showAppbarTitle ? 10 : 0, top: 10),
          duration: Duration(milliseconds: 250),
          child: const Text(
            "Catalog",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: IconButton(
            onPressed: null,
            icon: Image.asset(
              "search".toIcon,
              width: 25,
              height: 25,
            ),
          ),
        ),
      ],
    );
  }

  Row buildFilterArea() {
    return Row(
      children: [
        Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/ic_filter.png",
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "Filter",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 25),
        Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFf58d15),
            ),
            child: Image.asset(
              "assets/icons/ic_nike.png",
              width: 40,
              height: 40,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 15),
        Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFf58d15),
            ),
            child: Image.asset(
              "assets/icons/ic_adidas.png",
              width: 40,
              height: 40,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 15),
        Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(
              "assets/icons/ic_puma.png",
              width: 40,
              height: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class CardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width, 0);
    path0.quadraticBezierTo(
        size.width, size.height * 0.7500000, size.width, size.height);
    path0.lineTo(0, size.height);
    path0.quadraticBezierTo(
        size.width * 0.0002000, size.height * 0.3320000, 0, 0);
    path0.quadraticBezierTo(size.width * 0.0021143, size.height * 0.3363000,
        size.width * 0.1140571, size.height * 0.4027000);
    path0.lineTo(size.width * 0.8877714, size.height * 0.4062000);
    path0.quadraticBezierTo(
        size.width * 1.0035143, size.height * 0.3682000, size.width, 0);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
