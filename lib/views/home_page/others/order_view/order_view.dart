import 'package:eat_incredible_app/controller/orderdetails/orderdetails_bloc.dart';
import 'package:eat_incredible_app/controller/orderitems/orderitems_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/widgets/banner/custom_banner.dart';
import 'package:eat_incredible_app/widgets/track_order/track_order_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderViewPage extends StatefulWidget {
  final String id;
  final String oid;
  const OrderViewPage({super.key, required this.id, required this.oid});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  String isUrl = "";
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    context
        .read<OrderitemsBloc>()
        .add(OrderitemsEvent.orderItems(orderId: widget.id));

    context
        .read<OrderdetailsBloc>()
        .add(OrderdetailsEvent.orderDetails(orderId: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 0, 0, 1)),
          onPressed: () => Get.back(),
        ),
        title: Center(
          child: Text(
            'Order ${widget.oid}',
            style: GoogleFonts.poppins(
              color: const Color.fromRGBO(97, 97, 97, 1),
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String url = isUrl.toString();
                await Share.share(" $url");
              },
              icon: Icon(
                Icons.share,
                color: const Color.fromRGBO(0, 0, 0, 1),
                size: 14.sp,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
          return Future.value();
        },
        child: BlocConsumer<OrderdetailsBloc, OrderdetailsState>(
          bloc: context.read<OrderdetailsBloc>(),
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              success: (orderDetails) {
                setState(() {
                  isUrl = orderDetails[0].invoice.toString();
                });
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () {
                return const LinearProgressIndicator(
                  color: Colors.red,
                  backgroundColor: Color.fromARGB(92, 244, 67, 54),
                );
              },
              orElse: () {
                return const Text("somthing went wrong");
              },
              success: (orderDetails) {
                return BlocConsumer<OrderitemsBloc, OrderitemsState>(
                  bloc: context.read<OrderitemsBloc>(),
                  listener: (context, state) {},
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () {
                        return const LinearProgressIndicator(
                          color: Colors.red,
                          backgroundColor: Color.fromARGB(92, 244, 67, 54),
                        );
                      },
                      orElse: () {
                        return const Text("somthing ");
                      },
                      success: (orderItems) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Order Summary",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.w600,
                                    )),

                                const SizedBox(height: 10),
                                const OrderTimeline(
                                  index: 2,
                                ),
                                const SizedBox(height: 10),
                                orderDetails[0].totalItems == 1
                                    ? Text(
                                        "${orderDetails[0].totalItems} item in this order",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xff000000),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ))
                                    : Text(
                                        "${orderDetails[0].totalItems} items in this order",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xff000000),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                SizedBox(height: 15.h),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                //!======================================================================================
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: orderItems.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 15.h),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 60.h,
                                              width: 60.w,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: CustomPic(
                                                height: 60.h,
                                                width: 60.w,
                                                imageUrl:
                                                    orderItems[index].image,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              height: 55.h,
                                              width: 240.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    orderItems[index]
                                                        .productName,
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xff2C2C2C),
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${orderItems[index].weight} x ${orderItems[index].qnty}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                              0xff949494),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "₹${orderItems[index].price}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                              0xff000000),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      );
                                    }),
                                Row(
                                  children: List.generate(20, (index) {
                                    return Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 1,
                                          width: 10,
                                          color: const Color(0XFF5A5A5A),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Bill Details",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Item Total",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff5A5A5A),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: Text(
                                    "₹${orderDetails[0].itemTotal}",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff5A5A5A),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Delivery partner fee",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff5A5A5A),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: Text(
                                    "₹${orderDetails[0].deliveryFee}",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff5A5A5A),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Discount Applied",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff35AB39),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: Text(
                                    "₹${orderDetails[0].discount}",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff35AB39),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Total Bill",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Text(
                                    "₹${orderDetails[0].totalBill}",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Order Details",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff000000),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Order id",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff787878),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    orderDetails[0].odrNumber,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Payment",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff787878),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    orderDetails[0].payment,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Deliver to",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff787878),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    orderDetails[0].address,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    "Order placed",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff787878),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Placed on Tue, ${orderDetails[0].placedOn}",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff000000),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 36,
                                        backgroundColor:
                                            const Color(0xffFF8F94),
                                        child: Image.asset(
                                          "assets/images/helper.png",
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Need help with your order?",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xff000000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Support is alaways avaliable",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xff787878),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.w,
                                      right: 15.w,
                                      top: 25.h,
                                      bottom: 10.h),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 40.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        side: const BorderSide(
                                          color: Color.fromARGB(255, 255, 0, 0),
                                          width: 1,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'Repeat Order',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                          color: const Color.fromARGB(
                                              255, 255, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //!=================================================================================================
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  child: SizedBox(
                                    height: 40.h,
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xffE20A13)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // ignore: deprecated_member_use
                                        launch(orderDetails[0].invoice ?? "");
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
                              ],
                            ),
                          ),
                        );
                      },
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
