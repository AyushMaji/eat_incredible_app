import 'package:eat_incredible_app/utils/barrel.dart';

class FaqCard extends StatelessWidget {
  final String title;
  final String description;
  const FaqCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(
              description,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff3C3C3C),
              ),
            ),
            children: [
              ListTile(
                title: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color.fromRGBO(97, 97, 97, 1),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ],
      ),
    );
  }
}
