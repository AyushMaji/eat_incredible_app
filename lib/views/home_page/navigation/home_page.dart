import 'package:bot_toast/bot_toast.dart';
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
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //* call the bloc to get the data from the api
  void getData() {
    context.read<CategoryBloc>().add(const CategoryEvent.getCategory());
    context
        .read<ProductListBloc>()
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomPic(
                  imageUrl: "https://i.imgur.com/dt6mgQ3.png",
                  height: 120.h,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: BlocConsumer<CategoryBloc, CategoryState>(
                  bloc: context.read<CategoryBloc>(),
                  listener: (context, state) {
                    state.when(
                        initial: () {},
                        loading: () {},
                        loaded: (_) {},
                        failure: (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e),
                              action: SnackBarAction(
                                label: 'Retry',
                                onPressed: () {
                                  context
                                      .read<CategoryBloc>()
                                      .add(const CategoryEvent.getCategory());
                                },
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 29, 30, 29),
                              behavior: SnackBarBehavior.fixed,
                            ),
                          );
                        });
                  },
                  builder: (context, state) {
                    return state.maybeWhen(orElse: () {
                      return SizedBox(
                          height: 70.h,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }, loaded: (category) {
                      return SizedBox(
                        height: 70.h,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: category.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                context.read<ProductListBloc>().add(
                                    ProductListEvent.fetchProductList(
                                        categoryId: category[index].id));
                                Get.to(() => FilterPage(
                                      categoryIndex: index,
                                      categoryId: category[index].id,
                                      categoryName: category[index].name,
                                    ));
                              },
                              child: Card(
                                  elevation: 0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomPic(
                                          imageUrl: category[index]
                                              .categoryImg
                                              .toString(),
                                          height: 40.h,
                                          width: 55.w),
                                      Text(category[index].name.toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal)),
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
                    imageUrl: "https://i.imgur.com/AL3Ra5Q.png",
                    height: 130.h,
                    width: double.infinity),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SizedBox(
                  height: 100.h,
                  width: double.infinity,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 40,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Stack(
                            children: [
                              CustomPic(
                                  imageUrl:
                                      "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&auto=format&fit=crop&w=400&q=60",
                                  height: 100.h,
                                  width: 80.w),
                              Positioned(
                                child: Container(
                                  height: 100.h,
                                  width: 75.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    gradient: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFF040404),
                                        Colors.transparent,
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
                                    "20% OFF",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                child: CustomPic(
                    imageUrl: "https://i.imgur.com/7v4Vgbh.png",
                    height: 150.h,
                    width: double.infinity),
              ),
              BlocConsumer<ProductListBloc, ProductListState>(
                bloc: context.read<ProductListBloc>(),
                listener: (context, state) {
                  state.when(
                      initial: () {},
                      loading: () {},
                      loaded: (_) {},
                      failure: (e) {
                        CustomSnackbar.flutterSnackbarWithAction(e, 'Retry',
                            () {
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
                        baseColor: const Color.fromARGB(44, 222, 220, 220),
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
                                        if (pid == productList[index].id) {
                                          CustomSnackbar.loading();
                                        }
                                      },
                                      success: (msg, pid) {
                                        if (pid == productList[index].id) {
                                          context.read<ProductListBloc>().add(
                                              const ProductListEvent
                                                      .fetchProductList(
                                                  categoryId: "98989"));
                                          BotToast.showText(text: msg);
                                        }
                                      },
                                      failure: (e) {});
                                },
                                builder: (context, state) {
                                  return ProductCard(
                                    isCart: productList[index].iscart,
                                    imageUrl:
                                        productList[index].thumbnail.toString(),
                                    title: productList[index]
                                        .productName
                                        .toString(),
                                    disprice: productList[index]
                                        .originalPrice
                                        .toString(),
                                    price:
                                        productList[index].salePrice.toString(),
                                    quantity:
                                        productList[index].weight.toString(),
                                    percentage: productList[index]
                                        .discountPercentage
                                        .toString(),
                                    productId: productList[index].id.toString(),
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
                                              productid: productList[index]
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
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
