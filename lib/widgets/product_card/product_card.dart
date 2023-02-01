import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/others/cart_page/cart_page.dart';
import 'package:eat_incredible_app/widgets/banner/custom_banner.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productId;
  final String percentage;
  final String title;
  final String disprice;
  final String price;
  final String quantity;
  //  final ValueChanged<String>? onChanged;
  final GestureTapCallback? ontap;
  final GestureTapCallback? addtocartTap;
  final bool? isCart;
  final String cartId;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.disprice,
    required this.price,
    required this.quantity,
    // required this.onChanged,
    required this.ontap,
    required this.percentage,
    required this.addtocartTap,
    this.isCart,
    required this.productId,
    required this.cartId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String productId = '';
  @override
  void initState() {
    productId = widget.productId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1.w),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5.w,
          ),
        ),
        width: 130.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 95.h,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      CustomPic(
                        imageUrl: widget.imageUrl,
                        height: 95.h,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 3.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff02A008),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.sp),
                              topRight: Radius.circular(10.sp),
                            ),
                          ),
                          height: 19.h,
                          width: 52.w,
                          child: Center(
                            child: Text(
                              "${widget.percentage}% OFF",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          fontSize: 10.8.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 0.6.h,
                      ),
                      Text(
                        widget.quantity,
                        style: GoogleFonts.poppins(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(148, 148, 148, 1)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.sp, bottom: 7.sp, right: 5.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     int.parse(widget.disprice) !=   int.parse(widget.price)? Text("₹ ${widget.disprice}",
                          style: GoogleFonts.poppins(
                              fontSize: 8.5.sp,
                              decoration: TextDecoration.lineThrough,
                              color: const Color.fromRGBO(148, 148, 148, 1))) :  Text(""),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.1.h),  
                        child: Text(
                          "₹ ${widget.price}",
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  (widget.isCart == true)
                      ? GestureDetector(
                          onTap: () {
                            Get.to(() => const CartPage());
                          },
                          child: Container(
                            height: 24.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(2, 160, 8, 1),
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color: const Color.fromRGBO(2, 160, 8, 1)),
                            ),
                            child: Center(
                              child: Text(
                                "View cart",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.sp,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            widget.addtocartTap!();
                          },
                          child: Container(
                            height: 24.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color: const Color.fromRGBO(2, 160, 8, 1)),
                            ),
                            child: Center(
                              child: Text(
                                "Add",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.sp,
                                    color: const Color.fromRGBO(2, 160, 8, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
