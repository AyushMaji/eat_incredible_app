import 'package:eat_incredible_app/controller/user_info/user_info_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/others/my_address/my_address_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController editphoneController = TextEditingController();
  final TextEditingController editemailController = TextEditingController();

  @override
  void initState() {
    context.read<UserInfoBloc>().add(const UserInfoEvent.getUserInfo());

    super.initState();
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            'Account Info',
            style: GoogleFonts.poppins(
              color: const Color.fromRGBO(97, 97, 97, 1),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: IconButton(
              icon: const Icon(Icons.search, color: Color.fromRGBO(0, 0, 0, 1)),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: BlocConsumer<UserInfoBloc, UserInfoState>(
        listener: (context, state) {
          state.maybeMap(
            loaded: (state) {
              nameController.text = state.userInfo.name ?? 'Enter Your Name';
              phoneController.text =
                  state.userInfo.mobile ?? 'Enter Your Phone';
              emailController.text = state.userInfo.email ?? 'Enter Your Email';
              addressController.text =
                  state.userInfo.address ?? 'Add Your Address';
              editemailController.text =
                  state.userInfo.email ?? 'Enter Your Email';
              editphoneController.text =
                  state.userInfo.mobile ?? 'Enter Your Phone';
            },
            error: (value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(value.message),
                behavior: SnackBarBehavior.floating,
              ));
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(orElse: () {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                child: SizedBox(
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(44, 222, 220, 220),
                    highlightColor: Colors.grey[100]!,
                    child: Image.asset(
                      "assets/images/userinfo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }, loaded: (userInfoModel) {
            return Scaffold(
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: SizedBox(
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      primary: const Color(0xffE20A13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.sp,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://img.freepik.com/free-photo/close-up-young-successful-man-smiling-camera-standing-casual-outfit-against-blue-background_1258-66609.jpg?w=2000'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 13.sp,
                              backgroundColor:
                                  const Color.fromRGBO(255, 214, 214, 1),
                              child: Icon(
                                Icons.camera_alt,
                                color: const Color(0xffE20A13),
                                size: 15.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'Change Photo',
                      style: GoogleFonts.poppins(
                        color: const Color(0xffE20A13),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: ' Enter your name',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromRGBO(97, 97, 97, 1),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              suffixIcon: Icon(
                                Icons.edit,
                                color: const Color(0xffE20A13),
                                size: 15.sp,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffCFCFCF),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE20A13)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextField(
                            readOnly: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 690.h,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w, vertical: 10.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Add Phone Number',
                                              style: GoogleFonts.poppins(
                                                color: const Color.fromRGBO(
                                                    97, 97, 97, 1),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w),
                                        child: TextField(
                                          autofocus: true,
                                          controller: editphoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText:
                                                ' Enter your phone number',
                                            hintStyle: GoogleFonts.poppins(
                                              color: const Color.fromRGBO(
                                                  97, 97, 97, 1),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            suffixIcon: Icon(
                                              Icons.edit,
                                              color: const Color(0xffE20A13),
                                              size: 15.sp,
                                            ),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xffCFCFCF),
                                              ),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffE20A13)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w, vertical: 10.h),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 44.h,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              // ignore: deprecated_member_use
                                              primary: const Color(0xffE20A13),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.sp),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.5.h),
                                            ),
                                            child: const Text(
                                              "Send OTP",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: ' Enter your Phone Number',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromRGBO(97, 97, 97, 1),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              suffixIcon: Icon(
                                Icons.edit,
                                color: const Color(0xffE20A13),
                                size: 15.sp,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffCFCFCF),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE20A13)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: emailController,
                            readOnly: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w, vertical: 10.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Add Email',
                                              style: GoogleFonts.poppins(
                                                color: const Color.fromRGBO(
                                                    97, 97, 97, 1),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w),
                                        child: TextField(
                                          autofocus: true,
                                          controller: editemailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: ' Enter your email',
                                            hintStyle: GoogleFonts.poppins(
                                              color: const Color.fromRGBO(
                                                  97, 97, 97, 1),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            suffixIcon: Icon(
                                              Icons.edit,
                                              color: const Color(0xffE20A13),
                                              size: 15.sp,
                                            ),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xffCFCFCF),
                                              ),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffE20A13)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w, vertical: 10.h),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 44.h,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              // ignore: deprecated_member_use
                                              primary: const Color(0xffE20A13),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.sp),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.5.h),
                                            ),
                                            child: const Text(
                                              "Send OTP",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              hintText: ' Enter your email',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromRGBO(97, 97, 97, 1),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              suffixIcon: Icon(
                                Icons.edit,
                                color: const Color(0xffE20A13),
                                size: 15.sp,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffCFCFCF),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE20A13)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextField(
                            readOnly: true,
                            onTap: () => Get.to(() => const MyAddressPage()),
                            controller: addressController,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromRGBO(97, 97, 97, 1),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              suffixIcon: Icon(
                                Icons.edit,
                                color: const Color(0xffE20A13),
                                size: 15.sp,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffCFCFCF),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffCFCFCF),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    )
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
