import 'package:flutter/material.dart';
import 'package:ui_challenge_1/features/basket/view/basket_view.dart';
import 'package:ui_challenge_1/features/home/view/home_view.dart';
import 'package:ui_challenge_1/features/product/view/product_details_view.dart';
import 'package:ui_challenge_1/model/product.dart';

const String initialRoute = "splash";

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return normalNavigate(route: "/", page: const HomeView());
      case "details":
        var product = settings.arguments as Product;
        return slideNavigate(
          page: ProductDetailsView(product: product),
          transition: NavigateTransition.RightToLeft,
        );
      case "basket":
        return slideNavigate(
          page: const BasketView(),
          transition: NavigateTransition.BottomToTop,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> normalNavigate(
      {required String route, required Widget page}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: route),
      builder: (_) => page,
    );
  }

  static Route slideNavigate(
      {required Widget page, NavigateTransition? transition}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        late final Offset begin;
        if (transition != null) {
          switch (transition) {
            case NavigateTransition.BottomToTop:
              begin = const Offset(0.0, 1.0);
              break;
            case NavigateTransition.RightToLeft:
              begin = const Offset(1.0, 0.0);
              break;
            default:
              begin = const Offset(0.0, 0.0);
              break;
          }
        } else {
          begin = const Offset(0.0, 0.0);
        }

        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

enum NavigateTransition {
  BottomToTop,
  RightToLeft,
}
