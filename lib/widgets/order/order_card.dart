import 'package:eat_incredible_app/utils/barrel.dart';

class OrderCard extends StatelessWidget {
  final String image;
  final String orderId;
  final String orderDate;
  final String orderStatus;
  final String orderTotal;
  final String orderQuantity;
  final GestureTapCallback viewDetails;

  const OrderCard({
    super.key,
    required this.image,
    required this.orderId,
    required this.orderDate,
    required this.orderStatus,
    required this.orderTotal,
    required this.orderQuantity,
    required this.viewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.sp),
            border: Border.all(
              color: const Color(0xffD0D0D0),
              width: 1,
            ),
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
                child: SizedBox(
                  height: 69.5.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 63.h,
                            width: 63.w,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(208, 208, 208, 0.25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromRGBO(208, 208, 208, 1),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(image, height: 50.h),
                            ),
                          ),
                          SizedBox(
                            width: 14.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                orderId,
                                style: GoogleFonts.poppins(
                                  color: const Color.fromRGBO(0, 0, 0, 19),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Total Amount\n₹$orderTotal',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff404040),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 1.5.w,
                          right: 1.5.w,
                        ),
                        height: 23.4.h,
                        decoration: BoxDecoration(
                          color: orderStatus == 'Delivered'
                              ? const Color.fromRGBO(2, 160, 8, 0.25)
                              : orderStatus == 'Cancelled'
                                  ? const Color.fromRGBO(160, 2, 2, 0.25)
                                  : const Color.fromRGBO(211, 104, 5, 0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                // icon
                                Icons.circle,
                                color: orderStatus == 'Delivered'
                                    ? const Color.fromRGBO(2, 160, 8, 1)
                                    : orderStatus == 'Cancelled'
                                        ? const Color.fromRGBO(226, 10, 19, 1)
                                        : const Color.fromARGB(
                                            166, 211, 105, 5),
                                size: 8.sp,
                              ),
                              SizedBox(
                                width: 1.3.w,
                              ),
                              Text(
                                orderStatus,
                                style: GoogleFonts.poppins(
                                  color: orderStatus == 'Delivered'
                                      ? const Color.fromRGBO(2, 160, 8, 1)
                                      : orderStatus == 'Cancelled'
                                          ? const Color.fromRGBO(226, 10, 19, 1)
                                          : const Color.fromARGB(
                                              166, 211, 105, 5),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              const Divider(
                  color: Color.fromRGBO(208, 208, 208, 1), thickness: 1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderQuantity,
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(225, 97, 97, 97),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          'Placed on $orderDate',
                          style: GoogleFonts.poppins(
                            color: const Color.fromRGBO(97, 97, 97, 1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: viewDetails,
                          child: Row(
                            children: [
                              Text(
                                'View Details',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xff02A008),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Icon(
                                // icon
                                Icons.arrow_forward_ios,
                                color: const Color.fromRGBO(2, 160, 8, 1.0),
                                size: 10.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
