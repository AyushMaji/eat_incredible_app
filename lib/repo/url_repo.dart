class UrlRepo {
  static const loginwithOtp = "send_mobile_otp.php";
  static const loginwithemail = "send_email_otp.php";
  static const verifyOtp = "mobile_otp_verify.php";
  static const verifyemailOtp = "email_verify.php";
  static const logout = "mobile_otp_logout.php";
  static const category = 'category.php';
  static const productList = 'product_list.php';
  static String productListCategory(String categoryid) =>
      'category_wise_product_list.php?cat_id=$categoryid';
  static String productDetail(String productid) =>
      'each_product.php?id=$productid';

  static String addTocart(String productid) => 'add_to_cart.php?id=$productid';
  static const userInfo = 'account_info.php';

  static String editEmail(String email) => 'send_email_otp.php?id=$email';
  static String editPhone(String phone) => 'send_phone_otp.php?id=$phone';

  //! made all demo url for testing and development
  static const removeCart = 'remove_cart.php';
  static const getCartDetails = 'cart_details.php';
}
