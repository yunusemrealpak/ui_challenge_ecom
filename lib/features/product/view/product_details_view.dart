import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ui_challenge_1/core/base_viewmodel.dart';
import 'package:ui_challenge_1/core/extensions/context_extensions.dart';
import 'package:ui_challenge_1/core/extensions/string_extensions.dart';
import 'package:ui_challenge_1/features/product/viewmodel/product_details_viewmodel.dart';

import 'package:ui_challenge_1/model/product.dart';

import '../../../core/base_provider.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  const ProductDetailsView({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  bool _showSizes = false;
  bool _showColors = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1250), (e) {
      setState(() {
        _showSizes = true;
      });

      timer?.cancel();

      timer = Timer.periodic(const Duration(milliseconds: 600), (e) {
        setState(() {
          _showColors = true;
        });
        return;
      });

      return;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductDetailsViewModel>(
      viewModel: ProductDetailsViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      builder: (context, model, _) => Scaffold(
        backgroundColor: const Color(0xFFa8a8cd),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: FadeIn(
                        duration: const Duration(milliseconds: 750),
                        delay: const Duration(milliseconds: 1450),
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Image.asset(
                            widget.product.image.toPng,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SlideInUp(
                      duration: const Duration(milliseconds: 450),
                      delay: const Duration(milliseconds: 350),
                      from: MediaQuery.of(context).size.height * 0.66,
                      child: buildContent(context, model),
                    ),
                  ),
                ],
              ),
              FadeIn(
                duration: const Duration(milliseconds: 350),
                delay: const Duration(milliseconds: 900),
                child: buildAppbar(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildAppbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.heart_broken,
            ),
          ),
        ],
      ),
    );
  }

  Container buildContent(BuildContext context, ProductDetailsViewModel model) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFf1f5fe),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          topRight: Radius.circular(55),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 950),
              from: 25,
              child: Text(
                widget.product.brand,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 1050),
              from: 25,
              child: Text(
                widget.product.model,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 1150),
              from: 25,
              child: const Text(
                "Size",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey),
              ),
            ),
            Visibility(
              visible: _showSizes,
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.sizes.length,
                  itemBuilder: (context, index) {
                    final size = model.sizes.elementAt(index);
                    return InkWell(
                      onTap: () => model.setSize(size),
                      child: FadeInUp(
                        from: 15,
                        duration: const Duration(milliseconds: 550),
                        delay: Duration(milliseconds: (index + 2) * 100),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: model.selectedSize?.id == size.id
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            size.size,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: model.selectedSize?.id == size.id
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 1750),
              from: 25,
              child: const Text(
                "Color",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey),
              ),
            ),
            Visibility(
              visible: _showColors,
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.colors.length,
                  itemBuilder: (context, index) {
                    final color = model.colors.elementAt(index);
                    return InkWell(
                      onTap: () => model.setColor(color),
                      child: FadeInUp(
                        from: 15,
                        duration: const Duration(milliseconds: 550),
                        delay: Duration(milliseconds: (index + 2) * 100),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: model.selectedColor == color
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                            ),
                            color: model.selectedColor == color
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 2300),
                  from: 25,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "\$${widget.product.price}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => model.addToCart(widget.product),
                          child: Container(
                            padding: context.paddingLow,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.add_shopping_cart),
                                SizedBox(width: 15),
                                Text(
                                  "Add to cart",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
