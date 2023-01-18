import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:eat_incredible_app/controller/address/view_address_list/view_addresslist_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_iteam/cart_iteams_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/add_address/add_address_page.dart';
import 'package:eat_incredible_app/views/home_page/others/coupon_code/coupon_code.dart';
import 'package:eat_incredible_app/views/home_page/others/edit_address/edit_address_page.dart';
import 'package:eat_incredible_app/views/home_page/others/product_details/product_details.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
import 'package:eat_incredible_app/widgets/addtocart/cart_product.dart';
import 'package:eat_incredible_app/widgets/addtocart/product_notavailable.dart';
import 'package:eat_incredible_app/widgets/coupon_code/use_coupon.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? pincode;
  ProductListBloc productListBloc = ProductListBloc();
  bool isGuest = true;
  int addressIndex = 0;
  late Razorpay razorpay;
  CartIteamsBloc isAvailableIteamsBloc = CartIteamsBloc();

  Future<void> checkGuest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      setState(() {
        isGuest = false;
      });
    }
    getData();
  }

  @override
  void initState() {
    checkGuest();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void getData() {
    BlocProvider.of<CartDetailsBloc>(context)
        .add(const CartDetailsEvent.getCartDetails(coupon: ''));
    context.read<CartIteamsBloc>().add(const CartIteamsEvent.getCartIteams());
    productListBloc
        .add(const ProductListEvent.fetchProductList(categoryId: "98989"));
    !isGuest
        ? context
            .read<ViewAddresslistBloc>()
            .add(const ViewAddresslistEvent.getAddressList())
        : null;
  }

  //* create order #######################################################################################################
  void createOrder() async {
    String username = 'rzp_live_vqdCt0dXhP4PHg'; // razorpay pay key
    String password = "NgDLPyiDRPuQpcXy1E3GKTDv"; // razoepay secret key
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": 1 * 100,
      "currency": "INR",
      "receipt": "rcptid_11",
      "payment_capture": 1,
      // "notes": {
      //   "address": "Hello World",
      // },
    };
    var res = await http.post(
      Uri.https("api.razorpay.com",
          "v1/orders"), //https://api.razorpay.com/v1/orders // Api provided by Razorpay Official 💙
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openCheckout(jsonDecode(res.body)['id']); // 😎🔥
    }
    print(res.body);
  }
  //*#######################################################################################################

  //!=======================================================================================================
  void openCheckout(String orderId) async {
    var options = {
      'key': 'rzp_live_vqdCt0dXhP4PHg',
      "amount": 1 * 100,
      'order_id': orderId,
      'name': 'Eatincredible.co.in',
      // 'prefill': {'contact': '', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  //!========================================= Handeling Payments Events ==============================================================
  handlerPaymentSuccess(PaymentSuccessResponse response) {
    final key = utf8.encode('NgDLPyiDRPuQpcXy1E3GKTDv');
    final bytes = utf8.encode('${response.orderId}|${response.paymentId}');
    final hmacSha256 = Hmac(sha256, key);
    final generatedSignature = hmacSha256.convert(bytes);
    if (generatedSignature.toString() == response.signature) {
      log("Payment was successful!");
      //Handle what to do after a successful payment.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success : payment successful"),
            // content: const Text("Are you sure you wish to delete this item?"),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    // PlaceOrderPrepaid();
                  },
                  child: const Text("OK"))
              // ),
            ],
          );
        },
      );
    } else {
      log("The payment was unauthentic!");
    }
  }

  handlerErrorFailure(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error : Something went wrong"),
          // content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  // PlaceOrderPrepaid();
                },
                child: const Text("OK"))
            // ),
          ],
        );
      },
    );
  }

  handlerExternalWallet(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success : payment successful"),
          // content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("OK")),
            // FlatButton(
            //   onPressed: () => Navigator.of(context).pop(false),
            //   child: const Text("CANCEL"),
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Center(
          child: Text("Cart",
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff616161),
              )),
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
          return Future.value();
        },
        child: SingleChildScrollView(
          child: BlocConsumer<CartDetailsBloc, CartDetailsState>(
            bloc: context.read<CartDetailsBloc>(),
            listener: (context, state) {},
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox(),
                loading: (() {
                  return const LinearProgressIndicator(
                    backgroundColor: Color.fromARGB(80, 76, 175, 79),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  );
                }),
                loaded: (cartDetailModel) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.h),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Container(
                            height: 40.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(2, 160, 8, 0.1),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xff02A008),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Add items to it now",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff02A008),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child:
                                      Text(cartDetailModel.totalItem.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff02A008),
                                          )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 13.h),
                      // ListTile(
                      //   title: const Text("Delivery in 1-2 days",
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w700,
                      //         color: Colors.black,
                      //       )),
                      //   subtitle: const Text("4 items",
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w400,
                      //         color: Colors.black,
                      //       )),
                      //   leading: Icon(
                      //     Icons.delivery_dining,
                      //     color: Colors.black,
                      //     size: 33.sp,
                      //   ),
                      // ),
                      BlocConsumer<CartIteamsBloc, CartIteamsState>(
                        bloc: context.read<CartIteamsBloc>(),
                        listener: (context, state) {},
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: SizedBox(
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromARGB(44, 222, 220, 220),
                                    highlightColor: Colors.grey[100]!,
                                    child: Image.asset(
                                      "assets/images/addtocart_iteam.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            loaded: (cartIteamsList) {
                              return cartIteamsList.isEmpty
                                  ? Text("No items in cart",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff616161),
                                      ))
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: cartIteamsList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.2.h),
                                          child: Dismissible(
                                            onDismissed: ((direction) {
                                              CartRepo.deleteCartIteam(
                                                      cartIteamsList[index]
                                                          .id
                                                          .toString())
                                                  .then((value) => {
                                                        BotToast.showText(
                                                            text:
                                                                'removed from cart',
                                                            textStyle: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        12.5.sp,
                                                                    color: Colors
                                                                        .white),
                                                            duration:
                                                                const Duration(
                                                                    seconds:
                                                                        1)),
                                                        getData()
                                                      });
                                            }),
                                            key: UniqueKey(),
                                            background: Container(
                                              color: Colors.red,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 26.0),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                              ),
                                              child: CartProduct(
                                                imageUrl: cartIteamsList[index]
                                                    .thumbnail
                                                    .toString(),
                                                title: cartIteamsList[index]
                                                    .productName
                                                    .toString(),
                                                price: cartIteamsList[index]
                                                    .originalPrice
                                                    .toString(),
                                                disprice: cartIteamsList[index]
                                                    .salePrice
                                                    .toString(),
                                                quantity: cartIteamsList[index]
                                                    .weight
                                                    .toString(),
                                                iteam: int.parse(
                                                    cartIteamsList[index]
                                                        .quantity
                                                        .toString()),
                                                onChanged: (String value) {
                                                  CartRepo.updateCartIteam(
                                                          cartIteamsList[index]
                                                              .id
                                                              .toString(),
                                                          value)
                                                      .then((value) => {
                                                            getData(),
                                                          });
                                                },
                                                ontap: () {},
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top: 2.h,
                          bottom: 5.h,
                        ),
                        child: const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, bottom: 15.h),
                            child: Text("Before you checkout",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      BlocConsumer<ProductListBloc, ProductListState>(
                        bloc: productListBloc,
                        listener: (context, state) {
                          state.when(
                              initial: () {},
                              loading: () {},
                              loaded: (_) {},
                              failure: (e) {
                                CustomSnackbar.flutterSnackbarWithAction(
                                    e, 'Retry', () {
                                  context.read<ProductListBloc>().add(
                                      const ProductListEvent.fetchProductList(
                                          categoryId: "98989"));
                                }, context);
                              });
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                              orElse: () => SizedBox(
                                  height: 165.h,
                                  child: const Text('something went wrong')),
                              loading: () {
                                return SizedBox(
                                  height: 165.h,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          44, 222, 220, 220),
                                      highlightColor: Colors.grey[100]!,
                                      child: Image.asset(
                                        "assets/images/itemList.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              loaded: (productList) {
                                return productList.isEmpty
                                    ? Text(
                                        "No Product Found",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            color: const Color.fromARGB(
                                                30, 0, 0, 0),
                                            fontWeight: FontWeight.bold),
                                      )
                                    : SizedBox(
                                        height: 165.h,
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: productList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.w),
                                                child: BlocConsumer<CartBloc,
                                                    CartState>(
                                                  listener: (context, state) {
                                                    state.when(
                                                        initial: () {},
                                                        loading: (pid) {
                                                          if (pid ==
                                                              productList[index]
                                                                  .variantId) {
                                                            CustomSnackbar
                                                                .loading();
                                                          }
                                                        },
                                                        success: (msg, pid) {
                                                          if (pid ==
                                                              productList[index]
                                                                  .variantId) {
                                                            getData();

                                                            BotToast.showText(
                                                                text: msg);
                                                          }
                                                        },
                                                        failure: (e) {});
                                                  },
                                                  builder: (context, state) {
                                                    return ProductCard(
                                                      isCart: productList[index]
                                                          .iscart,
                                                      imageUrl:
                                                          productList[index]
                                                              .thumbnail
                                                              .toString(),
                                                      title: productList[index]
                                                          .productName
                                                          .toString(),
                                                      disprice:
                                                          productList[index]
                                                              .originalPrice
                                                              .toString(),
                                                      price: productList[index]
                                                          .salePrice
                                                          .toString(),
                                                      quantity:
                                                          productList[index]
                                                              .weight
                                                              .toString(),
                                                      percentage: productList[
                                                              index]
                                                          .discountPercentage
                                                          .toString(),
                                                      productId:
                                                          productList[index]
                                                              .id
                                                              .toString(),
                                                      cartId: productList[index]
                                                          .categoryId
                                                          .toString(),
                                                      ontap: () {
                                                        Get.to(() =>
                                                            ProductDetails(
                                                              productId:
                                                                  productList[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                              catId: productList[
                                                                      index]
                                                                  .categoryId
                                                                  .toString(),
                                                            ));
                                                      },
                                                      addtocartTap: () {
                                                        context.read<CartBloc>().add(
                                                            CartEvent.addToCart(
                                                                productid: productList[
                                                                        index]
                                                                    .variantId
                                                                    .toString()));
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            }),
                                      );
                              });
                        },
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: UseCouponCard(
                          onTap: () {
                            Get.to(() => const CouponsCode());
                          },
                          isApplyCoupon: cartDetailModel.applyCopunCode,
                          onTapremove: () {
                            HapticFeedback.lightImpact();
                            getData();
                          },
                          couponCode: cartDetailModel.couponCode.toString(),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: Text("total amount ",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        trailing: Text("₹ ${cartDetailModel.totalPrice}",
                            style: GoogleFonts.poppins(fontSize: 13.sp)),
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: Text("Coupon discount",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        trailing: Text("₹ ${cartDetailModel.couponDiscount}",
                            style: GoogleFonts.poppins(fontSize: 13.sp)),
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: Text("Delivery charges",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        trailing: Text("₹ ${cartDetailModel.deliveryCharges}",
                            style: GoogleFonts.poppins(fontSize: 13.sp)),
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -2),
                        title: Text("Bill Total",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            )),
                        trailing: Text("₹ ${cartDetailModel.totalBill}",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: SizedBox(
                          height: 42.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isGuest
                                ? () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Log In / Sign Up'),
                                        content: const Text(
                                            'Please login or signup to continue shopping with us.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Get.to(() => const SignupPage());
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                : cartDetailModel.totalItem.toString() != '0'
                                    ? () {
                                        showbottomsheet(context);
                                      }
                                    : () {
                                        Get.snackbar(
                                          "Cart is empty",
                                          "Please add some items to cart",
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff02A008),
                            ),
                            child: Text("Checkout",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> showbottomsheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Builder(builder: (context) {
            return StatefulBuilder(
                builder: (context, setState) => SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: TextButton.icon(
                                onPressed: () {
                                  Get.to(() => const AddAddressPage());
                                },
                                icon: const Icon(Icons.add,
                                    color: Color(0xffE20A13)),
                                label: Text('Add new address',
                                    style: TextStyle(
                                      color: const Color(0xff000000),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            BlocConsumer<ViewAddresslistBloc,
                                ViewAddresslistState>(
                              listener: (context, state) {
                                state.maybeWhen(
                                  orElse: () {},
                                  loaded: (addressList) {
                                    setState(() {
                                      pincode =
                                          addressList[0].pincode.toString();
                                    });
                                  },
                                );
                              },
                              builder: (context, state) {
                                return state.maybeWhen(orElse: () {
                                  return const Text('something went wrong');
                                }, loading: () {
                                  return const Center(
                                      child: LinearProgressIndicator(
                                    color: Color(0xffE20A13),
                                    backgroundColor:
                                        Color.fromARGB(72, 226, 10, 17),
                                  ));
                                }, loaded: (addressList) {
                                  return addressList.isEmpty
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Center(
                                            child: Text('',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      47, 0, 0, 0),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        )
                                      : ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: addressList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: addressIndex ==
                                                        index
                                                    ? BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.r),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xffE20A13),
                                                          width: 1,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset:
                                                                const Offset(
                                                                    0, 1),
                                                          ),
                                                        ],
                                                      )
                                                    : null,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 8.h),
                                                child: ListTile(
                                                    onTap: () {
                                                      addressIndex = index;
                                                      pincode =
                                                          addressList[index]
                                                              .pincode
                                                              .toString();
                                                      setState(() {});
                                                    },
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    leading: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: const Color(
                                                          0xffE20A13),
                                                      size: 20.sp,
                                                    ),
                                                    title: Text(
                                                        addressList[index]
                                                            .locality
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        )),
                                                    subtitle: Text(
                                                        addressList[index]
                                                            .address
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    10.sp)),
                                                    trailing: TextButton(
                                                        onPressed: () {
                                                          Get.to(() =>
                                                              EditAddressPage(
                                                                addressId:
                                                                    addressList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                address: addressList[
                                                                        index]
                                                                    .address
                                                                    .toString(),
                                                                city: addressList[
                                                                        index]
                                                                    .city
                                                                    .toString(),
                                                                state: addressList[
                                                                        index]
                                                                    .location
                                                                    .toString(),
                                                                pincode: addressList[
                                                                        index]
                                                                    .pincode
                                                                    .toString(),
                                                                locality: addressList[
                                                                        index]
                                                                    .locality
                                                                    .toString(),
                                                                landmark: addressList[
                                                                        index]
                                                                    .landmark
                                                                    .toString(),
                                                              ));
                                                        },
                                                        child: Text(
                                                          'Edit',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 10.sp,
                                                            color: const Color
                                                                    .fromARGB(
                                                                244,
                                                                226,
                                                                10,
                                                                17),
                                                          ),
                                                        ))),
                                              ),
                                            );
                                          },
                                        );
                                }, error: (message) {
                                  return Center(
                                    child: Text(message),
                                  );
                                });
                              },
                            ),
                            BlocConsumer<CartIteamsBloc, CartIteamsState>(
                              bloc: isAvailableIteamsBloc,
                              listener: (context, state) {
                                state.maybeWhen(
                                  orElse: () {},
                                  loaded: (cartIteamList) async {
                                    if (cartIteamList.isEmpty) {
                                      createOrder();
                                      Logger().e(pincode);
                                      // another api
                                    } else {
                                      dialogbox(context);
                                    }
                                  },
                                );
                              },
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          left: 10.w,
                                          right: 10.w,
                                          bottom: 10.h,
                                          top: 5.h),
                                      child: SizedBox(
                                        height: 40.h,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            isAvailableIteamsBloc.add(
                                                CartIteamsEvent.isAvailable(
                                                    pincode.toString()));
                                            // dialogbox(context);

                                            //  createOrder();
                                            // Get.offAll(() => const OrderConfirmPage());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff02A008),
                                          ),
                                          child: Text("Next Step",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () {
                                    return Center(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10.w,
                                              right: 10.w,
                                              bottom: 12.h,
                                              top: 11.h),
                                          child:
                                              const CircularProgressIndicator(
                                            color: Color(0xff02A008),
                                          )),
                                    );
                                  },
                                );
                              },
                            ),
                          ]),
                    ));
          });
        });
  }

  Future<dynamic> dialogbox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel",
                  style: TextStyle(
                    color: Color(0xff02A008),
                  )),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff02A008),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  "Go to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
          title: Text(
            "Not available in your area.",
            style: GoogleFonts.poppins(
                color: const Color.fromARGB(179, 212, 3, 3),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 200.h,
            child: BlocConsumer<CartIteamsBloc, CartIteamsState>(
              bloc: isAvailableIteamsBloc,
              listener: (context, state) {},
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const Text("");
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  loaded: (cartIteamsList) {
                    return cartIteamsList.isEmpty
                        ? const Text('noData')
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartIteamsList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.2.h),
                                child: Dismissible(
                                  onDismissed: ((direction) {
                                    CartRepo.deleteCartIteam(
                                            cartIteamsList[index].id.toString())
                                        .then((value) => {getData()});
                                  }),
                                  key: UniqueKey(),
                                  background: Container(
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(left: 26.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: ProductNotAvailable(
                                      imageUrl: cartIteamsList[index]
                                          .thumbnail
                                          .toString(),
                                      title: cartIteamsList[index]
                                          .productName
                                          .toString(),
                                      price: cartIteamsList[index]
                                          .originalPrice
                                          .toString(),
                                      disprice: cartIteamsList[index]
                                          .salePrice
                                          .toString(),
                                      quantity: cartIteamsList[index]
                                          .weight
                                          .toString(),
                                      iteam: 0,
                                      onChanged: () {},
                                    ),
                                  ),
                                ),
                              );
                            });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
