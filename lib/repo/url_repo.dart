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
  static String removecart(String productid) => 'remove_cart.php?id=$productid';
  static const updateCart = 'update_cart_quantity.php';

  static const userInfo = 'account_info.php';
  static String editEmail(String email) => 'send_email_otp.php?id=$email';
  static String editPhone(String phone) => 'send_phone_otp.php?id=$phone';

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
}
