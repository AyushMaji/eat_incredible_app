import 'package:eat_incredible_app/api/network.dart';

class CartRepo {
  static final Network network = Network();
  static Future addToCart(String productid) async {
    return await network.addToCart(productid);
  }
}
