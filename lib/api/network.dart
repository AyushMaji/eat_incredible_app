import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eat_incredible_app/api/api_helper.dart';
import 'package:eat_incredible_app/repo/url_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final client = ApiHelper();

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

  Future<Response> verifyemailOtp(
      String email, String otp, String guestId) async {
    return await client.postRequest(UrlRepo.verifyemailOtp, data: {
      "email": email,
      "otp": otp,
      "guest_id": guestId,
    });
  }

  Future<Response> logout() async {
    return await client.postRequest(UrlRepo.logout, data: {});
  }

  Future<Response> insertName(
      String name, String value, String loginType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    return await client.postRequest(UrlRepo.insertName, data: {
      "name": name,
      loginType: value,
      "token": token,
    });
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

  Future<Response> getCartDetails() async {
    return await client.postRequest(UrlRepo.cartDetails, data: {});
  }

  Future<Response> getCartIteam() async {
    return await client.postRequest(UrlRepo.cartIteam, data: {});
  }

  Future<Response> deleteCartIteam(String pid) async {
    return await client.postRequest(UrlRepo.removecart(pid), data: {});
  }

  Future<Response> updateCartCount(
    String pid,
    String count,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String guestId = prefs.getString('guest_id') ?? '';
    return token != ''
        ? await client.postRequest(UrlRepo.updateCart, data: {
            "token": token,
            "p_id": pid,
            "quantity": count,
          })
        : await client.postRequest(UrlRepo.updateCart, data: {
            "guest_id": guestId,
            "p_id": pid,
            "quantity": count,
          });
  }

  Future<Response> getuserInfo() async {
    return await client.postRequest(UrlRepo.userInfo, data: {});
  }

  Future<Response> updateUserEmail(String email) async {
    return await client.postRequest(UrlRepo.editEmail(email), data: {});
  }

  Future<Response> updateUserPhone(String phone) async {
    return await client.postRequest(UrlRepo.editPhone(phone), data: {});
  }
  //! address ===================>

  Future<Response> getaddress() async {
    return await client.postRequest(UrlRepo.addressList, data: {});
  }

  Future<Response> addaddress(String locality, String landmark, String address,
      String city, String pincode, String location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    return await client.postRequest(UrlRepo.addaddress, data: {
      "token": token,
      "city": city,
      "location": location,
      "pincode": pincode,
      "locality": locality,
      "landmark": landmark,
      "address": address,
    });
  }

  Future<Response> updateaddress(
      String addressId,
      String locality,
      String landmark,
      String address,
      String city,
      String pincode,
      String location) async {
    return await client.postRequest(UrlRepo.updateaddress(addressId), data: {
      "city": city,
      "landmark": landmark,
      "address": address,
      "locality": locality,
      "pincode": pincode,
      "location": location,
    });
  }

  Future<Response> deleteaddress(String id) async {
    return await client.postRequest(UrlRepo.deleteaddress(id), data: {});
  }

  //! search api ===================>

  Future<Response> searchKey(String search) async {
    return await client.postRequest(UrlRepo.searchKey, data: {
      "search": search,
    });
  }

  Future<Response> searchProduct(String search) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String guestId = prefs.getString('guest_id') ?? '';
    String location = prefs.getString('location') ?? '';
    String pincode = prefs.getString('pincode') ?? '';
    log('location wererewrew$location');
    log('pincodewerwe $pincode');
    log('token werewrew $token');
    log('guestId werewrew $guestId');

    return token != ''
        ? await client.postRequest(UrlRepo.searchData, data: {
            "token": token,
            "search": search,
            "location": location,
            "pincode": pincode,
          })
        : await client.postRequest(UrlRepo.searchData, data: {
            "guest_id": guestId,
            "search": search,
            "location": location,
            "pincode": pincode,
          });
  }

  Future<Response> trendingSearch() async {
    return await client.postRequest(UrlRepo.treadingSearch);
  }
}
