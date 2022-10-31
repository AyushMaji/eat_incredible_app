import 'package:eat_incredible_app/api/network.dart';

class CartRepo {
  static final Network network = Network();
  static Future addToCart(String productid) async {
    return await network.addToCart(productid);
  }

  static Future getCartDetails() async {
    return await network.getCartDetails();
  }

  static Future getCartIteam() async {
    return await network.getCartIteam();
  }
}
