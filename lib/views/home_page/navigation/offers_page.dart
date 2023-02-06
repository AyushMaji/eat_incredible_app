import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/about/about_bloc.dart';
import 'package:eat_incredible_app/controller/coupon/coupon_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/widgets/banner/custom_banner.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferPage extends StatelessWidget {
  const OfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          context.read<CouponBloc>().add(const CouponEvent.getCouponList());
          context.read<AboutBloc>().add(const AboutEvent.aboutUs());
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
                      context
                          .read<CouponBloc>()
                          .add(const CouponEvent.getCouponList());
                      context.read<AboutBloc>().add(const AboutEvent.aboutUs());
                    },
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text(
                      "Retry",
                      style: TextStyle(color: Color.fromARGB(138, 17, 16, 16)),
                    ),
                  ),
                );
              },
              loading: () => const LinearProgressIndicator(
                color: Colors.red,
                backgroundColor: Color.fromARGB(73, 244, 67, 54),
              ),
              loaded: (about) {
                return BlocConsumer<CouponBloc, CouponState>(
                  bloc: context.read<CouponBloc>(),
                  listener: (context, state) {},
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return Center(
                          child: TextButton.icon(
                            onPressed: () {
                              context
                                  .read<CouponBloc>()
                                  .add(const CouponEvent.getCouponList());
                              context
                                  .read<AboutBloc>()
                                  .add(const AboutEvent.aboutUs());
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
                        return const LinearProgressIndicator(
                          color: Colors.red,
                          backgroundColor: Color.fromARGB(73, 244, 67, 54),
                        );
                      },
                      success: ((couponList) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 10.w),
                                child: CustomPic(
                                  imageUrl: about.banner4,
                                  height: 130.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.w, bottom: 15.h),
                                child: Text("Great Deals",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                              couponList.isEmpty
                                  ? SizedBox(
                                      height: 70.h,
                                      child: const Center(
                                          child: Text("No Coupons Available",
                                              style: TextStyle(
                                                  color: Colors.grey))))
                                  : SizedBox(
                                      height: 80.h,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: couponList.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                Clipboard.setData(ClipboardData(
                                                    text: couponList[index]
                                                        .couponCode
                                                        .toString()));
                                                BotToast.showText(
                                                    text: "Copied",
                                                    textStyle:
                                                        GoogleFonts.poppins(
                                                            fontSize: 12.5.sp,
                                                            color:
                                                                Colors.white),
                                                    duration: const Duration(
                                                        seconds: 1));
                                              },
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 12.w),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.sp),
                                                  child: CustomPic(
                                                    imageUrl: couponList[index]
                                                        .couponImg,
                                                    height: 90.h,
                                                    width: 150.w,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, top: 13.h, bottom: 3.h),
                                child: Text("Only for you",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.h, horizontal: 10.w),
                                child: CustomPic(
                                  imageUrl: about.banner5,
                                  height: 130.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 50.h,
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
