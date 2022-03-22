import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

abstract class BaseViewModel with ChangeNotifier {
  BuildContext? context;

  setContext(BuildContext c) => context = c;

  T getProvider<T>() => Provider.of<T>(context!, listen: false);
}