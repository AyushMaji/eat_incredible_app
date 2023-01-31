import 'package:eat_incredible_app/controller/update_user_data/update_user_data_bloc.dart';
import 'package:eat_incredible_app/controller/user_info/user_info_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
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
  bool isEdit = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    context.read<UserInfoBloc>().add(const UserInfoEvent.getUserInfo());
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
        bloc: context.read<UserInfoBloc>(),
        listener: (context, state) {
          state.maybeMap(
            loaded: (state) {
              nameController.text = state.userInfo.name ?? 'Enter Your Name';
              phoneController.text =
                  state.userInfo.mobile ?? 'Enter Your Phone';
              emailController.text = state.userInfo.email ?? 'Enter Your Email';
              addressController.text =
                  state.userInfo.address ?? 'Add Your Address';
              setState(() {
                isEdit = false;
              });
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
          return state.maybeWhen(
            orElse: () {
              return Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
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
            },
            loaded: (userInfoModel) {
              return Scaffold(
                bottomNavigationBar: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                  child: BlocConsumer<UpdateUserDataBloc, UpdateUserDataState>(
                    bloc: context.read<UpdateUserDataBloc>(),
                    listener: (context, state) {
                      state.maybeWhen(
                        orElse: () {},
                        success: (code, msg) {
                          CustomSnackbar.successSnackbar('success', msg);
                          getData();
                        },
                        failure: (msg) {
                          CustomSnackbar.errorSnackbar('error', msg);
                        },
                      );
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: isEdit
                                  ? () {
                                      if (nameController.text.isNotEmpty &&
                                          phoneController.text.isNotEmpty &&
                                          emailController.text.isNotEmpty) {
                                        context.read<UpdateUserDataBloc>().add(
                                              UpdateUserDataEvent
                                                  .updateUserData(
                                                nameController.text,
                                                emailController.text,
                                                phoneController.text,
                                              ),
                                            );
                                      }
                                    }
                                  : () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isEdit
                                    ? const Color(0xffE20A13)
                                    : const Color(0xffE20A13).withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.sp)),
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
                          );
                        },
                      );
                    },
                  ),
                ),
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        child: Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              onChanged: (value) {
                                setState(() {
                                  isEdit = true;
                                });
                              },
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
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  isEdit = true;
                                });
                              },
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
                              onChanged: (value) {
                                setState(() {
                                  isEdit = true;
                                });
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
                            // SizedBox(height: 10.h),
                            // TextField(
                            //   readOnly: true,
                            //   onTap: () => Get.to(() => const MyAddressPage()),
                            //   controller: addressController,
                            //   decoration: InputDecoration(
                            //     hintStyle: GoogleFonts.poppins(
                            //       color: const Color.fromRGBO(97, 97, 97, 1),
                            //       fontSize: 12.sp,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //     suffixIcon: Icon(
                            //       Icons.edit,
                            //       color: const Color(0xffE20A13),
                            //       size: 15.sp,
                            //     ),
                            //     enabledBorder: const UnderlineInputBorder(
                            //       borderSide: BorderSide(
                            //         color: Color(0xffCFCFCF),
                            //       ),
                            //     ),
                            //     focusedBorder: const UnderlineInputBorder(
                            //       borderSide: BorderSide(
                            //         color: Color(0xffCFCFCF),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
