import 'package:animate_do/animate_do.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/Item_search/item_search.dart';
import 'package:eat_incredible_app/views/home_page/others/cart_page/cart_page.dart';
import 'package:eat_incredible_app/views/home_page/others/product_details/product_details.dart';
import 'package:eat_incredible_app/widgets/addtocart/addtocart_bar.dart';
import 'package:eat_incredible_app/widgets/filter/filter_bar.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

class FilterPage extends StatefulWidget {
  final int categoryIndex;
  final String categoryName;
  final String categoryId;
  const FilterPage(
      {super.key,
      required this.categoryIndex,
      required this.categoryName,
      required this.categoryId});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final ScrollController _scrollController = ScrollController();
  late String filterIteamId;

  //*  this is the fuction which is called when the user refresh the page ==========>

  void getdata() {
    Logger().i(filterIteamId);
    context
        .read<ProductListBloc>()
        .add(ProductListEvent.fetchProductList(categoryId: filterIteamId));
    context
        .read<CartDetailsBloc>()
        .add(const CartDetailsEvent.getCartDetails(coupon: ''));
  }

  @override
  void initState() {
    super.initState();
    handleScroll();
    setState(() {
      filterIteamId = widget.categoryId;
    });
    getdata();
  }

  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Center(
            child: Text(
          widget.categoryName,
          style: GoogleFonts.poppins(
              color: const Color.fromRGBO(97, 97, 97, 1),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700),
        )),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color.fromRGBO(97, 97, 97, 1),
            ),
            onPressed: () {
              Get.to(() => const ItemSearch());
            },
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                children: [
                  FilterBar(
                    categoryIndex: widget.categoryIndex,
                    onChanged: (value) {
                      context.read<ProductListBloc>().add(
                          ProductListEvent.fetchProductList(categoryId: value));
                      setState(() {
                        filterIteamId = value;
                      });
                    },
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      strokeWidth: 2.7,
                      onRefresh: () {
                        getdata();
                        return Future.value();
                      },
                      child: BlocConsumer<ProductListBloc, ProductListState>(
                        bloc: context.read<ProductListBloc>(),
                        listener: (context, state) {
                          state.when(
                              initial: () {},
                              loading: () {},
                              loaded: (_) {},
                              failure: (e) {
                                CustomSnackbar.flutterSnackbar(
                                    e.toString(), context);
                              });
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () {
                              return Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    getdata();
                                  },
                                  icon: const Icon(Icons.refresh_outlined),
                                  label: const Text(
                                    "Retry",
                                    style: TextStyle(
                                        color: Color.fromARGB(138, 17, 16, 16)),
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
                                    baseColor: const Color.fromARGB(
                                        255, 242, 240, 240),
                                    highlightColor: Colors.grey[100]!,
                                    child: Image.asset(
                                      "assets/images/grid_loading.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            loaded: (productList) {
                              return productList.isEmpty
                                  ? Center(
                                      child: Text(
                                      "No Data",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              92, 97, 97, 97),
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold),
                                    ))
                                  : GridView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      controller: _scrollController,
                                      itemCount: productList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 165.h,
                                        crossAxisCount: 2,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return FadeInUp(
                                            from: 3,
                                            child: BlocConsumer<CartBloc,
                                                CartState>(
                                              bloc: context.read<CartBloc>(),
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
                                                        getdata();
                                                        BotToast.showText(
                                                            text: msg);
                                                      }
                                                    },
                                                    failure: (e) {});
                                              },
                                              builder: (context, state) {
                                                return ProductCard(
                                                  isCart:
                                                      productList[index].iscart,
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
                                                  productId: productList[index]
                                                      .id
                                                      .toString(),
                                                  cartId: filterIteamId,
                                                  ontap: () {
                                                    Get.to(() => ProductDetails(
                                                          productId:
                                                              productList[index]
                                                                  .id
                                                                  .toString(),
                                                          catId:
                                                              productList[index]
                                                                  .categoryId
                                                                  .toString(),
                                                        ));
                                                  },
                                                  addtocartTap: () {
                                                    context.read<CartBloc>().add(
                                                        CartEvent.addToCart(
                                                            productid:
                                                                productList[
                                                                        index]
                                                                    .variantId
                                                                    .toString()));
                                                  },
                                                );
                                              },
                                            ));
                                      });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocConsumer<CartDetailsBloc, CartDetailsState>(
              bloc: context.read<CartDetailsBloc>(),
              listener: (context, state) {},
              builder: (context, state) {
                return state.maybeWhen(orElse: () {
                  return const SizedBox();
                }, loaded: (cartDetails) {
                  return Positioned(
                    bottom: 10.h,
                    child: cartDetails.totalItem != 0 && _show == true
                        ? SlideInUp(
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
                          ),
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }

  //! animation filter bar =========================>>

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }
}
