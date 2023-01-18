import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/coupon/coupon_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/widgets/banner/custom_banner.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponsCode extends StatefulWidget {
  const CouponsCode({super.key});

  @override
  State<CouponsCode> createState() => _CouponsCodeState();
}

class _CouponsCodeState extends State<CouponsCode> {
  @override
  void initState() {
    getData();
    // paste clipboard data
    Clipboard.getData('text/plain').then((value) {
      if (value != null) {
        cupponcodeController.text = value.text!;
      }
    });
    super.initState();
  }

  getData() {
    context.read<CouponBloc>().add(const CouponEvent.getCouponList());
  }

  TextEditingController cupponcodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
            child: Text('Coupons ',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                )),
          ),
          actions: [
            Opacity(
              opacity: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            getData();
            return Future.value();
          },
          child: SingleChildScrollView(
              child: Column(children: [
            SizedBox(height: 10.h),
            Container(
              height: 45.h,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: cupponcodeController,
                decoration: InputDecoration(
                  hintText: 'Enter coupon code',
                  hintStyle: GoogleFonts.poppins(
                    color: const Color.fromRGBO(60, 60, 67, 1),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 235, 234, 234),
                  suffix: InkWell(
                    onTap: () async {
                      BlocProvider.of<CartDetailsBloc>(context).add(
                          CartDetailsEvent.getCartDetails(
                              coupon: cupponcodeController.text));
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('coupon', cupponcodeController.text);

                      Get.back();
                    },
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: const Color(0xff787878),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Avalible Coupons',
                    style: TextStyle(
                      color: const Color.fromRGBO(4, 4, 4, 1),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            BlocConsumer<CouponBloc, CouponState>(
              bloc: context.read<CouponBloc>(),
              listener: (context, state) {},
              builder: (context, state) {
                return state.maybeMap(
                  orElse: () {
                    return const Text("Something went wrong");
                  },
                  loading: (j) {
                    return const LinearProgressIndicator(
                      color: Colors.red,
                      backgroundColor: Color.fromARGB(69, 244, 67, 54),
                    );
                  },
                  success: (value) {
                    return value.couponList.isEmpty
                        ? SizedBox(
                            height: 200.h,
                            child: Center(
                              child: Text(
                                'No Coupons Available',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.couponList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 8.h),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      cupponcodeController.text = value
                                          .couponList[index].couponCode
                                          .toString();
                                      BotToast.showText(
                                          text:
                                              "${value.couponList[index].couponCode} Copied",
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: 12.5.sp,
                                              color: Colors.white),
                                          duration: const Duration(seconds: 1));
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.w),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                      child: CustomPic(
                                        imageUrl:
                                            value.couponList[index].couponImg,
                                        height: 125.h,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
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
          ])),
        ));
  }
}
