import 'dart:developer';

import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:logger/logger.dart';

class CartRepo {
  static final Network network = Network();

  static Future addToCart(String productid) async {
    try {
      var res = await network.addToCart(productid);
      Logger().d(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future getCartDetails(String couponCode) async {
    try {
      var res = await network.getCartDetails(couponCode);

      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future getCartIteam() async {
    try {
      var res = await network.getCartIteam();
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! check cart item is available or not

  static Future isAvailable(String pincode) async {
    try {
      var res = await network.checkProduct(pincode);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future deleteCartIteam(String cartid) async {
    try {
      var res = await network.deleteCartIteam(cartid);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Future updateCartIteam(String pid, String quantity) async {
    try {
      var res = await network.updateCartCount(pid, quantity);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! coupon code == >
  static Future couponList() async {
    try {
      var res = await network.couponCodeList();
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! orderlist ==>
  Future<ApiResult> orderList() async {
    try {
      var res = await network.orderList();
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! order details ==>
  Future<ApiResult> orderDetails(String orderid) async {
    try {
      var res = await network.orderDetails(orderid);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! order item ==>

  Future<ApiResult> orderItem(String orderid) async {
    try {
      var res = await network.orderItem(orderid);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! cancel order ==>
  Future<ApiResult> cancelOrder(String orderid, String reason) async {
    try {
      var res = await network.cancelOrder(orderid, reason);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! repeat order ==>
  Future<ApiResult> repeatOrder(String orderid) async {
    try {
      var res = await network.repeatOrder(orderid);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! orderType ==>
  Future<ApiResult> orderType(String paymentType) async {
    try {
      var res = await network.orderType(paymentType);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! order confirm ==>
  Future<ApiResult> orderConfirm(
      String oid, String status, String odrNumber) async {
    try {
      var res = await network.paymentConfirm(oid, status, odrNumber);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! invoice =>
  Future<ApiResult> invoice() async {
    try {
      var res = await network.invoiceOrder();
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      Logger().e(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! order confirm ==>
  Future<ApiResult> orderConfirmmsg() async {
    log("step -2 ");
    try {
      var res = await network.orderMessage();
      Logger().i('success');
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! apply coupon ==>
  Future<ApiResult> applyCoupon(String couponCode) async {
    try {
      var res = await network.applycoupon(couponCode);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //! remove coupon ===>
  Future<ApiResult> removeCoupon() async {
    try {
      var res = await network.removeCoupon();
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
