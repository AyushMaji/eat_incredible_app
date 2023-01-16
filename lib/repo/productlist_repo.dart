import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:logger/logger.dart';

class ProductListRepo {
  static final Network network = Network();
  Future<ApiResult> getProductListData(String categoryId) async {
    try {
      var res = (categoryId == '98989')
          ? await network.getProductList()
          : await network.getProductListByCategory(categoryId);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
