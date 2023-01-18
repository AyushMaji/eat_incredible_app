import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/widgets/banner/custom_banner.dart';

class ProductNotAvailable extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String disprice;
  final String price;
  final String quantity;
  final int iteam;
  final GestureTapCallback? onChanged;

  const ProductNotAvailable({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.disprice,
    required this.price,
    required this.quantity,
    required this.iteam,
    required this.onChanged,
  });

  @override
  State<ProductNotAvailable> createState() => _ProductNotAvailableState();
}

class _ProductNotAvailableState extends State<ProductNotAvailable> {
  late int addToCard;

  @override
  void initState() {
    addToCard = widget.iteam;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CustomPic(
                  imageUrl: widget.imageUrl,
                  height: 50.h,
                  width: 55.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(44, 44, 44, 1),
                      )),
                  SizedBox(height: 0.5.h),
                  Text(widget.quantity,
                      style: GoogleFonts.poppins(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(148, 148, 148, 1),
                      )),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text("₹ ${widget.disprice}",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(44, 44, 44, 1),
                          )),
                      SizedBox(width: 2.5.w),
                      Text("₹ ${widget.price}",
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(148, 148, 148, 1),
                            decoration: TextDecoration.lineThrough,
                          )),
                    ],
                  ),
                ],
              ),
              // add icon
            ],
          ),
          // GestureDetector(
          //   onTap:  onch ,
          //   child: const Icon(
          //     Icons.delete_outline_outlined,
          //     color: Colors.red,
          //   ),
          // ),
        ],
      ),
    );
  }
}
