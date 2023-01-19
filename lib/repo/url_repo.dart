class UrlRepo {
  static const loginwithOtp = "mobileotp.php";
  static const loginwithemail = "emailotp.php";
  static const verifyOtp = "mobileverify.php";
  static const verifyemailOtp = "emailverify.php";
  static const insertName = "insert_name.php";
  static const logout = "logout.php";
  static const category = 'category.php';
  static const productList = 'product_list.php';
  static String productListCategory(String categoryid) =>
      'category_wise_product_list.php?cat_id=$categoryid';
  static String productDetail(String productid) =>
      'each_product.php?id=$productid';

  static String addTocart(String productid) => 'add_to_cart.php?id=$productid';
  static const cartDetails = 'cart_details.php';
  static const cartIteam = 'cart_items.php';
  static const isAvailable = 'check_product.php';
  static String removecart(String productid) => 'remove_cart.php?id=$productid';
  static const updateCart = 'update_cart_quantity.php';

  static const userInfo = 'account_info.php';
  static String editUserInfo = 'update_user_info.php';

  //!! add all address api
  static const addaddress = 'add_user_address.php';
  static const addressList = 'view_user_address.php';
  static String deleteaddress(String addressid) =>
      'delete_user_address.php?id=$addressid';
  static String updateaddress(String addressid) =>
      'update_user_address.php?id=$addressid';
  //! search api ====
  static String searchKey = 'search.php';
  static String searchData = 'search_list.php';
  static String treadingSearch = 'trending_search.php';

  static String aboutApi = 'about_us.php';
  static String couponCode = 'coupon_list.php';
  static String orderList = "order_history.php";
  static String orderDetails = "order_bill_details.php";
  static String orderitems = "ordered_items.php";
  static String weightlist = "product_weight.php";

//! cencle api and repeate order apis
  static String cancelorder = "cancel_order.php";
  static String repeatorder = "repeat_order.php";
}
