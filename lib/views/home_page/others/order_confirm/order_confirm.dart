import 'dart:developer';

import 'package:eat_incredible_app/controller/invoice/invoice_bloc.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderConfirmPage extends StatefulWidget {
  const OrderConfirmPage({super.key});

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  InvoiceBloc invoiceBloc = InvoiceBloc();
  String url = '';
  @override
  void initState() {
    getData();
    invoiceBloc.add(
      const InvoiceEvent.getInvoice(),
    );

    super.initState();
  }

  getData() async {
    log("step -1 ");
    var res = await CartRepo().orderConfirmmsg();
    res.when(success: (value) {}, failure: (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share(url);
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: BlocConsumer<InvoiceBloc, InvoiceState>(
        bloc: invoiceBloc,
        listener: (context, state) {
          state.maybeWhen(
              orElse: () {},
              loaded: (invoice) {
                url = invoice.invoice;
                setState(() {});
              });
        },
        builder: (context, state) {
          return state.maybeWhen(orElse: () {
            return Container();
          }, loading: () {
            return const LinearProgressIndicator(
              color: Colors.red,
              backgroundColor: Color.fromARGB(102, 244, 67, 54),
            );
          }, loaded: (invoice) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 13.w, right: 13.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Image.asset(
                      'assets/images/order.png',
                      height: 90.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your order has been',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffE20A13),
                          ),
                        ),
                        Text(
                          'placed',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffE20A13),
                          ),
                        ),
                        SizedBox(height: 7.h),
                        // Text(
                        //   'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Velit suspendisse fusce ante erat nunc, ultricies.',
                        //   style: GoogleFonts.poppins(
                        //     fontSize: 12.sp,
                        //     fontWeight: FontWeight.w400,
                        //     color: const Color(0xff000000),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Details',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff000000),
                            ),
                          ),
                          Text(
                            '',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff000000),
                            ),
                          )
                          // TextButton(
                          //   onPressed: () {
                          //     Get.to(() => const OrderBill());
                          //   },
                          //   child: Text(
                          //     'View details',
                          //     style: GoogleFonts.poppins(
                          //       fontSize: 10.sp,
                          //       fontWeight: FontWeight.w400,
                          //       color: const Color(0xffE20A13),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff000000),
                            ),
                          ),
                          Text(
                            '₹ ${invoice.totalBill}',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff000000),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 5.w, right: 5.w, top: 1.5.h, bottom: 50.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order number',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff000000),
                            ),
                          ),
                          Text(
                            invoice.orderNumber,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff000000),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: SizedBox(
                        height: 40.h,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffE20A13)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // ignore: deprecated_member_use
                            launch(
                              invoice.invoice.toString(),
                              enableJavaScript: true,
                            );
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ), //icon data for elevated button
                          label: const Text("Download Invoice",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffffffff),
                              )),
                          //
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 13.w, vertical: 15.h),
                      child: SizedBox(
                        height: 42.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAll(() => const Navigation());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffE20A13)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: Text("Continue Shoping",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
