import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class BasketArea extends StatelessWidget {
  final bool cartOpacity;
  final bool contentOpacity;
  const BasketArea({
    Key? key,
    required this.cartOpacity,
    required this.contentOpacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CardClipper(),
      child: Container(
        height: 100,
        width: double.infinity,
        color: Colors.black,
        child: AnimatedOpacity(
          opacity: cartOpacity ? 1 : 0,
          duration: const Duration(milliseconds: 350),
          child: Row(
            children: [
              const Text(
                "Cart",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              AnimatedOpacity(
                opacity: contentOpacity ? 1 : 0,
                duration: const Duration(milliseconds: 350),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset("assets/images/im_nike_3.png"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
