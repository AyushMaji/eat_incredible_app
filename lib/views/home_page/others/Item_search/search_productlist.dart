import 'package:animate_do/animate_do.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/search/search_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/Item_search/item_search.dart';
import 'package:eat_incredible_app/views/home_page/others/cart_page/cart_page.dart';
import 'package:eat_incredible_app/views/home_page/others/product_details/product_details.dart';
import 'package:eat_incredible_app/widgets/addtocart/addtocart_bar.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

class SearchProductList extends StatefulWidget {
  final String search;
  const SearchProductList({super.key, required this.search});

  @override
  State<SearchProductList> createState() => _SearchProductListState();
}

class _SearchProductListState extends State<SearchProductList> {
  final SearchBloc searchBloc = SearchBloc();
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    searchBloc.add(SearchEvent.searchProduct(search: widget.search));
    context
        .read<CartDetailsBloc>()
        .add(const CartDetailsEvent.getCartDetails(coupon: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.search),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.off(() => const ItemSearch());
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
                  Expanded(
                    child: BlocConsumer<SearchBloc, SearchState>(
                      bloc: searchBloc,
                      listener: (context, state) {
                        state.maybeWhen(
                          orElse: () {},
                          success: (productList) {
                            Logger().e(productList.length);
                          },
                        );
                      },
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 242, 240, 240),
                                  highlightColor: Colors.grey[100]!,
                                  child: Image.asset(
                                    "assets/images/grid_loading.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                          success: (productList) {
                            return productList.isEmpty
                                ? const Center(child: Text("No Data"))
                                : GridView.builder(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
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
                                          child:
                                              BlocConsumer<CartBloc, CartState>(
                                            listener: (context, state) {
                                              state.when(
                                                  initial: () {},
                                                  loading: (pid) {
                                                    if (pid ==
                                                        productList[index]
                                                            .variantId) {
                                                      CustomSnackbar.loading();
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
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 5.h),
                                                child: ProductCard(
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
                                                  cartId: productList[index]
                                                      .categoryId
                                                      .toString(),
                                                ),
                                              );
                                            },
                                          ));
                                    });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            BlocConsumer<CartDetailsBloc, CartDetailsState>(
              listener: (context, state) {},
              builder: (context, state) {
                return state.maybeWhen(orElse: () {
                  return const SizedBox();
                }, loaded: (cartDetails) {
                  return Positioned(
                      bottom: 10.h,
                      child: SlideInUp(
                        child: AddtocartBar(
                          iteamCount: cartDetails.totalItem,
                          onTap: () {
                            Get.to(() => const CartPage());
                          },
                          totalAmount: cartDetails.totalPrice,
                        ),
                      ));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
