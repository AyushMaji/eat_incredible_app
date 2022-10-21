import 'package:dio/dio.dart';
import 'package:eat_incredible_app/api/api_helper.dart';
import 'package:eat_incredible_app/repo/url_repo.dart';

class Network {
  final client = ApiHelper();
  // sharefrefarance

  Future<Response> postlogin(String phone, String countryCode) async {
    return await client.postRequest(UrlRepo.loginwithOtp, data: {
      'phone': phone,
    });
  }

  Future<Response> postloginwithEmail(String email, String password) async {
    return await client.postRequest(UrlRepo.loginwithemail, data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> verifyOtp(String phone, String otp) async {
    return await client.postRequest(UrlRepo.verifyOtp, data: {
      "phone": phone,
      "otp": int.parse(otp),
    });
  }

  Future<Response> verifyemailOtp(String email, String otp) async {
    return await client.postRequest(UrlRepo.verifyemailOtp, data: {
      "email": email,
      "otp": otp,
    });
  }

  Future<Response> logout(String phone) async {
    return await client.postRequest(UrlRepo.logout, data: {});
  }

  Future<Response> getCategories() async {
    return await client.getRequest(UrlRepo.category);
  }

  Future<Response> getProductList() async {
    return await client.postRequest(UrlRepo.productList, data: {});
  }

  Future<Response> getProductListByCategory(String categoryId) async {
    return await client
        .postRequest(UrlRepo.productListCategory(categoryId), data: {});
  }

  Future<Response> getProductDetails(String productid) async {
    return await client.postRequest(UrlRepo.productDetail(productid), data: {});
  }

  Future<Response> addToCart(String productid) async {
    return await client.postRequest(UrlRepo.addTocart(productid), data: {});
  }
}
