import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';

class AddressRepo {
  static final Network network = Network();

  Future<ApiResult> getaddress() async {
    try {
      var res = await network.getaddress();
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> addaddress(
    String locality,
    String landmark,
    String address,
    String city,
    String pincode,
    String location,
  ) async {
    try {
      var res = await network.addaddress(
          locality, landmark, address, city, pincode, location);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> updateaddress({
    required String locality,
    required String landmark,
    required String address,
    required String city,
    required String pincode,
    required String location,
    required String addressId,
  }) async {
    try {
      var res = await network.updateaddress(
          locality, landmark, address, city, pincode, location, addressId);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> deleteaddress({
    required String addressId,
  }) async {
    try {
      var res = await network.deleteaddress(addressId);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
