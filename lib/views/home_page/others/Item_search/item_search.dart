import 'dart:developer';
import 'package:eat_incredible_app/controller/search/search_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/navigation/navigation.dart';
import 'package:eat_incredible_app/views/home_page/others/Item_search/search_productlist.dart';
import 'package:eat_incredible_app/views/home_page/others/product_details/product_details.dart';
import 'package:eat_incredible_app/widgets/product_card/product_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class ItemSearch extends StatefulWidget {
  const ItemSearch({super.key});

  @override
  State<ItemSearch> createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  final SearchBloc searchBloc = SearchBloc();
  final TextEditingController _searchController = TextEditingController();
  String searchKey = '';
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
                          ? const Icon(Icons.search)
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
        //  AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   leading: IconButton(
        //     icon: const Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       Get.back();
        //     },
        //   ),
        //   title: Center(
        //     child: Text("search",
        //         style: GoogleFonts.poppins(
        //           fontSize: 11.sp,
        //           fontWeight: FontWeight.w600,
        //           color: Colors.black,
        //         )),
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(
        //         Icons.filter_list,
        //         color: Colors.black,
        //       ),
        //       onPressed: () {},
        //     ),
        //   ],
        // ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            searchKey == ''
                ? Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12.w, top: 0.h, bottom: 15.h),
                        child: Row(
                          children: [
                            Text("Popular In your Area",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 165.h,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 12.w),
                                child: ProductCard(
                                  isCart: true,
                                  imageUrl:
                                      "https://img.freepik.com/free-photo/indian-chicken-biryani-served-terracotta-bowl-with-yogurt-white-background-selective-focus_466689-72554.jpg?w=996&t=st=1662382774~exp=1662383374~hmac=3195b0404799d307075e5326a2b654503021f07749f8327c762c38418dda67a7",
                                  title: "title",
                                  disprice: "200",
                                  price: "200",
                                  quantity: "200",
                                  percentage: '20%',
                                  addtocartTap: () {},
                                  productId: '',
                                  cartId: '',
                                  ontap: () {
                                    Get.to(() => const ProductDetails(
                                          productId: '',
                                          catId: '',
                                        ));
                                  },
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 13.w, top: 20.h, bottom: 6.h),
                        child: Row(
                          children: [
                            Text("Trending Searchs",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 8.w, top: 1.h),
                                child: FilterChip(
                                  side: const BorderSide(color: Colors.grey),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  label: Text('Vegetables',
                                      style: GoogleFonts.poppins(
                                          color: const Color.fromRGBO(
                                              120, 120, 120, 1),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400)),
                                  onSelected: (bool value) {
                                    log("$index iteam$value");
                                  },
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 13.w, top: 13.h, bottom: 15.h),
                        child: Row(
                          children: [
                            Text("your may also like",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 165.h,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 12.w),
                                child: ProductCard(
                                  imageUrl:
                                      "https://img.freepik.com/free-photo/indian-chicken-biryani-served-terracotta-bowl-with-yogurt-white-background-selective-focus_466689-72554.jpg?w=996&t=st=1662382774~exp=1662383374~hmac=3195b0404799d307075e5326a2b654503021f07749f8327c762c38418dda67a7",
                                  title: "title",
                                  disprice: "200",
                                  price: "200",
                                  quantity: "200",
                                  ontap: () {
                                    Get.to(() => const ProductDetails(
                                          productId: '',
                                          catId: '',
                                        ));
                                  },
                                  percentage: '20%',
                                  addtocartTap: () {},
                                  isCart: true,
                                  productId: '',
                                  cartId: '',
                                ),
                              );
                            }),
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
                                              search: search[index].toString(),
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
    );
  }
}
