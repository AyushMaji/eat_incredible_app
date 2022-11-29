import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_iteam/cart_iteams_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/coupon_code/coupon_code.dart';
import 'package:eat_incredible_app/views/home_page/others/location_search/location_search.dart';
import 'package:eat_incredible_app/views/home_page/others/order_confirm/order_confirm.dart';
import 'package:eat_incredible_app/views/home_page/others/product_details/product_details.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
import 'package:eat_incredible_app/widgets/addtocart/cart_product.dart';
import 'package:eat_incredible_app/widgets/coupon_code/use_coupon.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ProductListBloc productListBloc = ProductListBloc();
  bool isGuest = true;
  late Razorpay razorpay;
  Future<void> checkGuest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      setState(() {
        isGuest = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    checkGuest();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    super.initState();
  }

  void getData() {
    BlocProvider.of<CartDetailsBloc>(context)
        .add(const CartDetailsEvent.getCartDetails());
    context.read<CartIteamsBloc>().add(const CartIteamsEvent.getCartIteams());
    productListBloc
        .add(const ProductListEvent.fetchProductList(categoryId: "98989"));
  }


  //!============================================================
   void openCheckout() async {
    var options = {
      'key': 'rzp_test_VCMCUPxY6XXTS2',
      //'amount': 100,
      "amount": 1020 * 100,
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
  //!============================================================

  handlerPaymentSuccess(PaymentSuccessResponse response) {
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
                child: Text("OK"))
            // ),
          ],
        );
      },
    );

  }
  handlerErrorFailure(PaymentFailureResponse response) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => PaymentErrorPage()));

  }
  void handlerExternalWallet(ExternalWalletResponse response) {
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
      body: SingleChildScrollView(
        child: BlocConsumer<CartDetailsBloc, CartDetailsState>(
          listener: (context, state) {},
          builder: (context, state) {
            return state.maybeWhen(
              orElse: (() {
                return SizedBox(
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(44, 222, 220, 220),
                    highlightColor: Colors.grey[100]!,
                    child: Image.asset(
                      "assets/images/cart_page.png",
                      fit: BoxFit.cover,
                    ),
                  ),
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
                                                        .productId
                                                        .toString())
                                                .then((value) => {getData()});
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
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 26.0),
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
                                                            .productId
                                                            .toString(),
                                                        value)
                                                    .then((value) => {
                                                          Logger().e(value),
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
                        return state.maybeWhen(orElse: () {
                          return SizedBox(
                            child: Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(44, 222, 220, 220),
                              highlightColor: Colors.grey[100]!,
                              child: Image.asset(
                                "assets/images/itemList.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }, loaded: (productList) {
                          return SizedBox(
                            height: 165.h,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: BlocConsumer<CartBloc, CartState>(
                                      listener: (context, state) {
                                        state.when(
                                            initial: () {},
                                            loading: (pid) {
                                              if (pid ==
                                                  productList[index].id) {
                                                CustomSnackbar.loading();
                                              }
                                            },
                                            success: (msg, pid) {
                                              if (pid ==
                                                  productList[index].id) {
                                                getData();
                                                BotToast.showText(text: msg);
                                              }
                                            },
                                            failure: (e) {});
                                      },
                                      builder: (context, state) {
                                        return ProductCard(
                                          isCart: productList[index].iscart,
                                          imageUrl: productList[index]
                                              .thumbnail
                                              .toString(),
                                          title: productList[index]
                                              .productName
                                              .toString(),
                                          disprice: productList[index]
                                              .originalPrice
                                              .toString(),
                                          price: productList[index]
                                              .salePrice
                                              .toString(),
                                          quantity: productList[index]
                                              .weight
                                              .toString(),
                                          percentage: productList[index]
                                              .discountPercentage
                                              .toString(),
                                          productId:
                                              productList[index].id.toString(),
                                          cartId: productList[index]
                                              .categoryId
                                              .toString(),
                                          ontap: () {
                                            Get.to(() => ProductDetails(
                                                  productId: productList[index]
                                                      .id
                                                      .toString(),
                                                  catId: productList[index]
                                                      .categoryId
                                                      .toString(),
                                                ));
                                          },
                                          addtocartTap: () {
                                            context.read<CartBloc>().add(
                                                CartEvent.addToCart(
                                                    productid:
                                                        productList[index]
                                                            .id
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
                        isApplyCoupon: false,
                        onTapremove: () {
                          log("Remove Coupon");
                        },
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
                      title: Text("total tax ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                      trailing: Text("₹ ${cartDetailModel.totalTax}",
                          style: GoogleFonts.poppins(fontSize: 13.sp)),
                    ),
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      title: Text("Item Total (incl. taxes)",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                      trailing: Text("₹ ${cartDetailModel.totalPriceIncTax}",
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
                              : _showBottomSheet,
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
    );
  }

  // create a method to show the bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 160.h,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: const Color(0xffE20A13),
                        size: 25.sp,
                      ),
                      title: Text("Home",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                      subtitle: Text(
                          "B-1/2, 2nd Floor, Sector 63, Noida 201301  Sector 63, Noida 201301   ",
                          style: GoogleFonts.poppins(fontSize: 12.sp)),
                      trailing: TextButton(
                          onPressed: () {
                            Get.to(() => const LocationSearchPage());
                          },
                          child: Text("Change",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 240, 0, 0),
                              ))),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        bottom: 1.h,
                      ),
                      child: SizedBox(
                        height: 35.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            openCheckout();
                           // Get.offAll(() => const OrderConfirmPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff02A008),
                          ),
                          child: Text("Select Payment",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ]));
        });
  }
}
