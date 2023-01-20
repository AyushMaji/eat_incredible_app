import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/about/about_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/category/category_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/filter_page/filter_page.dart';
import 'package:eat_incredible_app/views/home_page/others/product_details/product_details.dart';
import 'package:eat_incredible_app/widgets/banner/custom_banner.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  final ProductListBloc productListOfferBloc;
  final ProductListBloc productListsugessionBloc;

  const HomePage(
      {super.key,
      required this.productListOfferBloc,
      required this.productListsugessionBloc});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getData() {
    context.read<CategoryBloc>().add(const CategoryEvent.getCategory());
    context.read<AboutBloc>().add(const AboutEvent.aboutUs());

    widget.productListOfferBloc
        .add(const ProductListEvent.fetchProductList(categoryId: "98989"));
    widget.productListsugessionBloc
        .add(const ProductListEvent.fetchProductList(categoryId: "98989"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () {
          getData();
          return Future.value();
        },
        child: BlocConsumer<AboutBloc, AboutState>(
          bloc: context.read<AboutBloc>(),
          listener: (context, state) {
            state.when(
                initial: () {},
                loading: () {},
                loaded: (_) {},
                error: (e) {
                  CustomSnackbar.flutterSnackbar(e.toString(), context);
                });
          },
          builder: (context, state) {
            return state.maybeWhen(
                orElse: () {
                  return Center(
                    child: TextButton.icon(
                      onPressed: () {
                        getData();
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
                loading: () => const LinearProgressIndicator(
                      color: Colors.red,
                      backgroundColor: Color.fromARGB(83, 244, 67, 54),
                    ),
                loaded: ((aboutModel) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: CustomPic(
                            imageUrl: aboutModel.banner1,
                            height: 120.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: BlocConsumer<CategoryBloc, CategoryState>(
                            bloc: context.read<CategoryBloc>(),
                            listener: (context, state) {},
                            builder: (context, state) {
                              return state.maybeWhen(orElse: () {
                                return SizedBox(
                                    height: 70.h,
                                    child: const Center(
                                        child: CircularProgressIndicator()));
                              }, loaded: (category) {
                                return SizedBox(
                                  height: 70.h,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: category.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => FilterPage(
                                                categoryIndex: index,
                                                categoryId: category[index].id,
                                                categoryName:
                                                    category[index].name,
                                              ));
                                        },
                                        child: Card(
                                            elevation: 0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomPic(
                                                  imageUrl: category[index]
                                                      .categoryImg
                                                      .toString(),
                                                  height: 40.h,
                                                  width: 55.w,
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(
                                                    category[index]
                                                        .name
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: CustomPic(
                            imageUrl: aboutModel.banner2,
                            height: 130.h,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SizedBox(
                            height: 100.h,
                            width: double.infinity,
                            child:
                                BlocConsumer<ProductListBloc, ProductListState>(
                              bloc: widget.productListOfferBloc,
                              listener: (context, state) {},
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return SizedBox(
                                        height: 70.h,
                                        child: const Center(
                                            child:
                                                CircularProgressIndicator()));
                                  },
                                  loaded: (productList) {
                                    return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: productList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(() => ProductDetails(
                                                  productId: productList[index]
                                                      .id
                                                      .toString(),
                                                  catId: productList[index]
                                                      .categoryId
                                                      .toString(),
                                                ));
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 6.w),
                                            child: ClipPath(
                                              clipper: ShapeBorderClipper(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 9.h,
                                                    child: CustomPic(
                                                      imageUrl:
                                                          productList[index]
                                                              .thumbnail,
                                                      height: 85.h,
                                                      width: 60.w,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: Container(
                                                      height: 100.h,
                                                      width: 85.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        gradient:
                                                            const LinearGradient(
                                                          begin: Alignment
                                                              .bottomCenter,
                                                          end: Alignment
                                                              .topCenter,
                                                          colors: [
                                                            Color(0xFF040404),
                                                            Color.fromARGB(
                                                                56, 0, 0, 0),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 9.h,
                                                    left: 10.w,
                                                    child: Center(
                                                      child: Text(
                                                        "${productList[index].discountPercentage}% OFF",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 13.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 10.w),
                          child: CustomPic(
                            imageUrl: aboutModel.banner3,
                            height: 150.h,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        BlocConsumer<ProductListBloc, ProductListState>(
                          bloc: widget.productListsugessionBloc,
                          listener: (context, state) {},
                          builder: (context, state) {
                            return state.maybeWhen(
                                orElse: () => const SizedBox(),
                                loading: () {
                                  return SizedBox(
                                    height: 165.h,
                                    child: Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          44, 222, 220, 220),
                                      highlightColor: Colors.grey[100]!,
                                      child: Image.asset(
                                        "assets/images/itemList.png",
                                        fit: BoxFit.contain,
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
                                                  padding: EdgeInsets.only(
                                                      left: 10.w),
                                                  child: BlocConsumer<CartBloc,
                                                      CartState>(
                                                    listener: (context, state) {
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
                                                          success: (msg, pid) {
                                                            if (pid ==
                                                                productList[
                                                                        index]
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
                                                        isCart:
                                                            productList[index]
                                                                .iscart,
                                                        imageUrl:
                                                            productList[index]
                                                                .thumbnail
                                                                .toString(),
                                                        title:
                                                            productList[index]
                                                                .productName
                                                                .toString(),
                                                        disprice:
                                                            productList[index]
                                                                .originalPrice
                                                                .toString(),
                                                        price:
                                                            productList[index]
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
                                                        cartId:
                                                            productList[index]
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
                                                          context
                                                              .read<CartBloc>()
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
                          height: 30.h,
                        ),
                      ],
                    ),
                  );
                }));
          },
        ),
      ),
    );
  }
}
