import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge_1/features/basket/view/basket_view.dart';
import 'package:ui_challenge_1/features/basket/viewmodel/basket_viewmodel.dart';
import 'package:ui_challenge_1/features/home/view/home_view.dart';
import 'package:ui_challenge_1/features/router.dart';
import 'package:ui_challenge_1/features/product/view/product_details_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BasketViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UI Challenge Ecom',
        theme: ThemeData(
            primaryColor: const Color(0xFFf58d15),
            primarySwatch:  Colors.orange,
            fontFamily: "Catamaran",
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            )),
        initialRoute: "/",
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
