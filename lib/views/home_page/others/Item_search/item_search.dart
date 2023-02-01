import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/controller/search/search_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/navigation/navigation.dart';
import 'package:eat_incredible_app/views/home_page/others/Item_search/search_productlist.dart';
import 'package:eat_incredible_app/views/home_page/others/product_details/product_details.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

class ItemSearch extends StatefulWidget {
  const ItemSearch({super.key});

  @override
  State<ItemSearch> createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  ProductListBloc productlistbloc = ProductListBloc();
  final SearchBloc searchBloc = SearchBloc();
  final TextEditingController _searchController = TextEditingController();
  String searchKey = '';
  @override
  void initState() {
    productlistbloc
        .add(const ProductListEvent.fetchProductList(categoryId: "98989"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchKey = value;
                      });
                      searchBloc.add(
                        SearchEvent.searchKey(search: value),
                      );
                    },
                    controller: _searchController,
                    autofocus: true,
                    onFieldSubmitted: (value) {
                      Logger().e(value);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 4.9.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.sp),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 235, 234, 234),
                      hintText: 'Search',
                      prefixIcon: IconButton(
                        onPressed: () {
                          Get.off(() => const Navigation());
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 20.sp,
                        ),
                      ),
                      suffixIcon: searchKey == ''
                          ? const Icon(
                              Icons.search,
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  searchKey = '';
                                });
                                _searchController.clear();
                                searchBloc.add(
                                  const SearchEvent.searchKey(search: ''),
                                );
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          productlistbloc.add(
            const ProductListEvent.fetchProductList(categoryId: "98989"),
          );
          context.read<SearchBloc>().add(const SearchEvent.trendingSearch());

          return Future.value();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              searchKey == ''
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 12.w, top: 0.h, bottom: 15.h),
                          child: Row(
                            children: [
                              Text("You may also like",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        BlocConsumer<ProductListBloc, ProductListState>(
                          bloc: productlistbloc,
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
                                orElse: () => SizedBox(
                                    height: 165.h,
                                    child: Center(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          productlistbloc.add(
                                            const ProductListEvent
                                                    .fetchProductList(
                                                categoryId: "98989"),
                                          );
                                          context.read<SearchBloc>().add(
                                              const SearchEvent
                                                  .trendingSearch());
                                        },
                                        icon:
                                            const Icon(Icons.refresh_outlined),
                                        label: const Text(
                                          "Retry",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  138, 17, 16, 16)),
                                        ),
                                      ),
                                    )),
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
                                                      left: 15.w),
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
                                                              productlistbloc.add(
                                                                  const ProductListEvent
                                                                          .fetchProductList(
                                                                      categoryId:
                                                                          "98989"));
                                                              BotToast.showText(
                                                                  text: msg);
                                                              context
                                                                  .read<
                                                                      CartDetailsBloc>()
                                                                  .add(const CartDetailsEvent
                                                                          .getCartDetails(
                                                                      coupon:
                                                                          ''));
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: 13.w, top: 20.h, bottom: 6.h),
                          child: Row(
                            children: [
                              Text("Trending",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                          child: BlocConsumer<SearchBloc, SearchState>(
                            bloc: context.read<SearchBloc>(),
                            listener: (context, state) {},
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () {
                                  return Container();
                                },
                                success: (search) {
                                  return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: search.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.w, top: 1.h),
                                          child: FilterChip(
                                            side: const BorderSide(
                                                color: Colors.grey),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            label: Text(search[index],
                                                style: GoogleFonts.poppins(
                                                    color: const Color.fromRGBO(
                                                        120, 120, 120, 1),
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            onSelected: (bool value) {
                                              HapticFeedback.lightImpact();
                                              _searchController.text =
                                                  search[index];
                                              searchKey = search[index];
                                              searchBloc.add(
                                                SearchEvent.searchKey(
                                                    search: searchKey),
                                              );
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : BlocConsumer<SearchBloc, SearchState>(
                      bloc: searchBloc,
                      listener: (context, state) {
                        state.maybeWhen(
                          orElse: () {},
                          success: (search) {},
                        );
                      },
                      builder: (context, state) {
                        return state.when(
                          loading: () {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          success: ((search) {
                            return search.isEmpty
                                ? const Center(child: Text("No Data Found"))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: search.length,
                                    itemBuilder: ((context, index) {
                                      return ListTile(
                                        onTap: () {
                                          _searchController.text =
                                              search[index].toString();
                                          Get.to(() => SearchProductList(
                                                search:
                                                    search[index].toString(),
                                              ));
                                        },
                                        leading: const Icon(Icons.search),
                                        title: Text(search[index].toString()),
                                      );
                                    }));
                          }),
                          failure: (String message) {
                            return Center(
                              child: Text(message),
                            );
                          },
                          initial: () {
                            return const Center(
                              child: Text("initial"),
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
