import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';

class CartRepo {
  static final Network network = Network();
  static Future addToCart(String productid) async {
    return await network.addToCart(productid);
  }

  static Future getCartDetails() async {
    try {
      var res = await network.getCartDetails();
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future getCartIteam() async {
    try {
      var res = await network.getCartIteam();
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
