import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eat_incredible_app/repo/url_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Interceptors extends InterceptorsWrapper {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (options.path.contains(UrlRepo.logout) ||
        options.path.contains(UrlRepo.userInfo) ||
        options.path.contains(UrlRepo.addressList) ||
        options.path.contains('delete_user_address.php')) {
      String token = prefs.getString('token') ?? '';
      options.data = {
        "token": token,
      };
    }

    if (options.path.contains(UrlRepo.productList) ||
        options.path.contains('category_wise_product_list.php') ||
        options.path.contains('each_product.php') ||
        options.path.contains('add_to_cart.php') ||
        options.path.contains(UrlRepo.cartDetails) ||
        options.path.contains(UrlRepo.cartIteam)) {
      String token = prefs.getString('token') ?? '';
      String guestId = prefs.getString('guest_id') ?? '';
      log("token $token");
      log("guestId $guestId");
      token != ''
          ? options.data = {"token": token}
          : options.data = {"guest_id": guestId};
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }
}
