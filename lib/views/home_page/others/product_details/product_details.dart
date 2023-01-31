import 'package:bot_toast/bot_toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/product_details/product_details_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/controller/weight_bloc/weight_bloc.dart';
import 'package:eat_incredible_app/model/weight/weight_model.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/cart_page/cart_page.dart';
import 'package:eat_incredible_app/widgets/addtocart/addtocart_bar.dart';
import 'package:eat_incredible_app/widgets/banner/custom_banner.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  final String catId;
  const ProductDetails(
      {super.key, required this.productId, required this.catId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int current = 0;
  final CarouselController controller = CarouselController();
  ProductDetailsBloc productDetailsBloc = ProductDetailsBloc();
  ProductListBloc productListBloc = ProductListBloc();
  WeightBloc weightBloc = WeightBloc();
  late String dropdownvalue;
  // ignore: non_constant_identifier_names
  String v_id = '';

  @override
  void initState() {
    getData(widget.productId, '');
    super.initState();
  }

  //* call the product details api and get the data from the api
  void getData(pid, vid) {
    productDetailsBloc.add(ProductDetailsEvent.getproductdetails(pid, vid));
    productListBloc
        .add(ProductListEvent.fetchProductList(categoryId: widget.catId));
    weightBloc.add(WeightEvent.getWeight(pid));
    context
        .read<CartDetailsBloc>()
        .add(const CartDetailsEvent.getCartDetails(coupon: ''));
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
      ),
      body: RefreshIndicator(
        onRefresh: () {
          getData(widget.productId, v_id);
          return Future.value();
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
              bloc: productDetailsBloc,
              listener: (context, state) {
                state.when(
                    initial: () {},
                    loading: () {},
                    loaded: (productDetails) {
                      setState(() {
                        dropdownvalue = productDetails[0].weight.toString();
                      });
                    },
                    failure: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.6.h, horizontal: 20.w),
                          action: SnackBarAction(
                            label: 'Retry',
                            onPressed: () {
                              context.read<ProductDetailsBloc>().add(
                                  ProductDetailsEvent.getproductdetails(
                                      widget.productId, v_id));
                            },
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 29, 30, 29),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    });
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return Center(
                      child: TextButton.icon(
                        onPressed: () {
                          getData(widget.productId, v_id);
                        },
                        icon: const Icon(Icons.refresh_outlined),
                        label: const Text(
                          "Retry",
                          style:
                              TextStyle(color: Color.fromARGB(138, 17, 16, 16)),
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Shimmer.fromColors(
                          baseColor: const Color.fromARGB(44, 222, 220, 220),
                          highlightColor: Colors.grey[100]!,
                          child: Image.asset(
                            "assets/images/product_details.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  loaded: (productdetails) {
                    return SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Banner ============== >
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: CarouselSlider(
                                carouselController: controller,
                                options: CarouselOptions(
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 1000),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  height: 230.h,
                                  viewportFraction: 1.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      current = index;
                                    });
                                  },
                                ),
                                items:
                                    productdetails[0].productMoreImg.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                          width: double.infinity,
                                          color: const Color.fromARGB(
                                              0, 255, 255, 255),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: CustomPic(
                                            imageUrl: i,
                                            height: 230.h,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                          ));
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: productdetails[0]
                                  .productMoreImg
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () =>
                                      controller.animateToPage(entry.key),
                                  child: Container(
                                    width: 7.5.sp,
                                    height: 7.5.sp,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 7.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: current == entry.key
                                            ? const Color.fromRGBO(
                                                226, 10, 19, 1)
                                            : const Color.fromRGBO(
                                                223, 223, 223, 1)),
                                  ),
                                );
                              }).toList(),
                            ),
                            //* Banner ============== >
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 11.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    productdetails[0].productName.toString(),
                                    style: GoogleFonts.poppins(
                                        color:
                                            const Color.fromRGBO(44, 44, 44, 1),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        String url = productdetails[0]
                                            .shareLink
                                            .toString();
                                        Logger().e(productdetails[0].shareLink);
                                        await Share.share(
                                            "${productdetails[0].productName} $url");
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                        size: 14.sp,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 13.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₹ ${productdetails[0].salePrice.toString()}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(
                                                44, 44, 44, 1)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                83, 0, 0, 0),
                                          ),
                                        ),
                                        width: 70.w,
                                        height: 25.h,
                                        child: BlocConsumer<WeightBloc,
                                            WeightState>(
                                          bloc: weightBloc,
                                          listener: (context, state) {
                                            state.maybeWhen(
                                                orElse: () {},
                                                loaded: (weightList) {});
                                          },
                                          builder: (context, state) {
                                            return state.maybeWhen(
                                              orElse: () {
                                                return const SizedBox();
                                              },
                                              loaded: (weightListModel) {
                                                return Center(
                                                  child: DropdownButton<String>(
                                                    underline: Container(),
                                                    menuMaxHeight: 200.h,
                                                    value: dropdownvalue,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 24.sp,
                                                    elevation: 12,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownvalue =
                                                            newValue ??
                                                                productdetails[
                                                                        0]
                                                                    .weight
                                                                    .toString();
                                                      });
                                                    },
                                                    items: weightListModel.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (WeightModel value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        onTap: () {
                                                          getData(
                                                              widget.productId,
                                                              value.id
                                                                  .toString());

                                                          setState(() {
                                                            v_id = value.id
                                                                .toString();
                                                          });
                                                        },
                                                        value: value.weight
                                                            .toString(),
                                                        child: Text(value.weight
                                                            .toString()),
                                                      );
                                                    }).toList(),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      productdetails[0].iscart == false
                                          ? BlocConsumer<CartBloc, CartState>(
                                              listener: (context, state) {
                                                state.when(
                                                    initial: () {},
                                                    loading: (productId) {},
                                                    success: (msg, producId) {
                                                      getData(widget.productId,
                                                          v_id);
                                                    },
                                                    failure: (error) {});
                                              },
                                              builder: (context, state) {
                                                return state.maybeWhen(
                                                  orElse: () {
                                                    return GestureDetector(
                                                      onTap: (() {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(CartEvent
                                                                .addToCart(
                                                              productid:
                                                                  productdetails[
                                                                          0]
                                                                      .variantId
                                                                      .toString(),
                                                            ));
                                                      }),
                                                      child: Container(
                                                        height: 24.h,
                                                        width: 60.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          border: Border.all(
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  2,
                                                                  160,
                                                                  8,
                                                                  1)),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Add",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 10.sp,
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    2,
                                                                    160,
                                                                    8,
                                                                    1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  loading: (productId) {
                                                    return Center(
                                                      child: Container(
                                                        height: 24.h,
                                                        width: 60.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          border: Border.all(
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  2,
                                                                  160,
                                                                  8,
                                                                  1)),
                                                        ),
                                                        child: Center(
                                                          child:
                                                              CupertinoActivityIndicator(
                                                            radius: 8.sp,
                                                            color: const Color
                                                                    .fromARGB(
                                                                162, 2, 160, 7),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : GestureDetector(
                                              onTap: (() {
                                                Get.to(() => const CartPage());
                                              }),
                                              child: Container(
                                                height: 24.h,
                                                width: 60.w,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      2, 160, 8, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              2, 160, 8, 1)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "View cart",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 10.sp,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 13.w, vertical: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Details',
                                    style: GoogleFonts.poppins(
                                        color:
                                            const Color.fromRGBO(44, 44, 44, 1),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // Text(
                                  //   'Description',
                                  //   style: GoogleFonts.poppins(
                                  //       color:
                                  //           const Color.fromRGBO(44, 44, 44, 1),
                                  //       fontSize: 10.sp,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                  HtmlWidget(
                                    productdetails[0].description,
                                    textStyle: GoogleFonts.poppins(
                                        color: const Color.fromRGBO(
                                            148, 148, 148, 1),
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w400),
                                  ),

                                  // ReadMoreText(
                                  //   productdetails[0].description,
                                  //   trimLines: 4,
                                  //   colorClickableText:
                                  //       const Color.fromARGB(192, 226, 10, 17),
                                  //   trimMode: TrimMode.Line,
                                  //   trimCollapsedText: 'Show more',
                                  //   trimExpandedText: ' Show less',
                                  //   moreStyle: TextStyle(
                                  //     fontSize: 9.sp,
                                  //     fontWeight: FontWeight.normal,
                                  //     color:
                                  //         const Color.fromRGBO(226, 10, 19, 1),
                                  //   ),
                                  //   style: GoogleFonts.poppins(
                                  //       color: const Color.fromRGBO(
                                  //           148, 148, 148, 1),
                                  //       fontSize: 10.5.sp,
                                  //       fontWeight: FontWeight.w500),
                                  // ),

                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text(
                                    'View Similar Items',
                                    style: GoogleFonts.poppins(
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                ],
                              ),
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
                                            const ProductListEvent
                                                    .fetchProductList(
                                                categoryId: "98989"));
                                      }, context);
                                    });
                              },
                              builder: (context, state) {
                                return state.maybeWhen(
                                    orElse: () => SizedBox(
                                        height: 165.h,
                                        child:
                                            const Text('something went wrong')),
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
                                              fit: BoxFit.contain,
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w),
                                                      child: BlocConsumer<
                                                          CartBloc, CartState>(
                                                        listener:
                                                            (context, state) {
                                                          state.when(
                                                              initial: () {},
                                                              loading: (pid) {
                                                                if (pid ==
                                                                    productList[
                                                                            index]
                                                                        .variantId) {
                                                                  CustomSnackbar
                                                                      .loading();
                                                                }
                                                              },
                                                              success:
                                                                  (msg, pid) {
                                                                if (pid ==
                                                                    productList[
                                                                            index]
                                                                        .variantId) {
                                                                  getData(
                                                                      widget
                                                                          .productId,
                                                                      v_id);
                                                                  BotToast
                                                                      .showText(
                                                                          text:
                                                                              msg);
                                                                }
                                                              },
                                                              failure: (e) {});
                                                        },
                                                        builder:
                                                            (context, state) {
                                                          return ProductCard(
                                                            isCart: productList[
                                                                    index]
                                                                .iscart,
                                                            imageUrl:
                                                                productList[
                                                                        index]
                                                                    .thumbnail
                                                                    .toString(),
                                                            title: productList[
                                                                    index]
                                                                .productName
                                                                .toString(),
                                                            disprice: productList[
                                                                    index]
                                                                .originalPrice
                                                                .toString(),
                                                            price: productList[
                                                                    index]
                                                                .salePrice
                                                                .toString(),
                                                            quantity:
                                                                productList[
                                                                        index]
                                                                    .weight
                                                                    .toString(),
                                                            percentage: productList[
                                                                    index]
                                                                .discountPercentage
                                                                .toString(),
                                                            productId:
                                                                productList[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                            cartId: productList[
                                                                    index]
                                                                .categoryId
                                                                .toString(),
                                                            ontap: () {
                                                              // add swaipable navigation

                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      SwipeablePageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ProductDetails(
                                                                  productId: productList[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  catId: productList[
                                                                          index]
                                                                      .categoryId
                                                                      .toString(),
                                                                ),
                                                              ));
                                                            },
                                                            addtocartTap: () {
                                                              context
                                                                  .read<
                                                                      CartBloc>()
                                                                  .add(CartEvent.addToCart(
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
                            SizedBox(
                              height: 70.h,
                            )
                          ]),
                    );
                  },
                );
              },
            ),
            BlocConsumer<CartDetailsBloc, CartDetailsState>(
              listener: (context, state) {},
              builder: (context, state) {
                return state.maybeWhen(orElse: () {
                  return const SizedBox();
                }, loaded: (cartDetails) {
                  return cartDetails.totalItem != 0
                      ? Positioned(
                          bottom: 10.h,
                          child: AddtocartBar(
                            iteamCount: cartDetails.totalItem,
                            onTap: () {
                              Get.to(() => const CartPage());
                            },
                            totalAmount: cartDetails.totalPrice,
                          ),
                        )
                      : const Opacity(
                          opacity: 0.0,
                          child: SizedBox(),
                        );
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
