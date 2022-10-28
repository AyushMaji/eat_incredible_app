import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eat_incredible_app/controller/login/login_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/navigation/navigation.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
import 'package:eat_incredible_app/views/verification_page/verification_email_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPageWithEmail extends StatefulWidget {
  const SignupPageWithEmail({super.key});

  @override
  State<SignupPageWithEmail> createState() => _SignupPageWithEmailState();
}

class _SignupPageWithEmailState extends State<SignupPageWithEmail> {
  Country? selectedCountry;
  String selectedCountryCode = '+91';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ConstantData constantData = ConstantData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 30.h,
        child: Center(
          child: Text.rich(
            TextSpan(
              text: 'I agree with your',
              style: TextStyle(
                color: const Color.fromRGBO(60, 60, 67, 1),
                fontSize: 12.sp,
              ),
              children: [
                TextSpan(
                  text: ' Terms',
                  style: TextStyle(
                    color: const Color.fromRGBO(4, 4, 4, 1),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: TextStyle(
                    color: const Color.fromRGBO(60, 60, 67, 1),
                    fontSize: 12.sp,
                  ),
                ),
                TextSpan(
                  text: 'Conditions',
                  style: TextStyle(
                    color: const Color.fromRGBO(4, 4, 4, 1),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 390.h,
                autoPlayCurve: Curves.easeInSine,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
              ),
              items: constantData.signupPageBanner.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.asset(
                      image,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'Get Fresh Fruits and ',
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  Text(
                    ' vegetables at your doresteps',
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.off(() => const SignupPage());
                    },
                    child: Text(
                      'Log in with phone number',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromRGBO(4, 4, 4, 1),
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: SizedBox(
                height: 46.h,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email can not be empty";
                    }
                    return null;
                  },
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
            //   child: SizedBox(
            //     height: 48.h,
            //     child: TextFormField(
            //       controller: _passwordController,
            //       keyboardType: TextInputType.visiblePassword,
            //       decoration: const InputDecoration(
            //         border: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.black,
            //           ),
            //         ),
            //         hintText: 'Password',
            //       ),
            //       validator: (value) {
            //         if (value!.isEmpty) {
            //           return "Email can not be empty";
            //         }
            //         return null;
            //       },
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 15.h,
            ),
            //! Login Button =========================== >
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                state.when(
                    initial: () {},
                    loading: () {},
                    loaded: (lodedData) {
                      log(lodedData.message);
                      Get.to(() => VerificationWithPage(
                            email: _emailController.text,
                            password: _emailController.text,
                          ));
                    },
                    failure: (e) {
                      Get.snackbar(
                        'Error',
                        e,
                        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                        colorText: Colors.white,
                      );
                    });
              },
              builder: (context, state) {
                return state.maybeWhen(
                  initial: () {
                    return Loginbtn(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    );
                  },
                  orElse: () {
                    return Loginbtn(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    );
                  },
                  loading: (() {
                    return SizedBox(
                        height: 70.h,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  }),
                  loaded: (logindata) {
                    return Loginbtn(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    );
                  },
                );
              },
            ),
            //! Login Button =========================== >
            SizedBox(
              height: 10.h,
            ),
            TextButton(
              onPressed: () {
                Get.off(() => const Navigation());
              },
              child: Text(
                'Skip Log In',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff3C3C43),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Loginbtn extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const Loginbtn({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      width: double.infinity,
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: const Color.fromRGBO(226, 10, 19, 1),
        ),
        onPressed: () {
          if (emailController.text.isEmpty) {
            Get.snackbar(
              'Error',
              'Please enter your Vaild Email and Password',
              backgroundColor: const Color.fromARGB(255, 255, 17, 0),
              colorText: Colors.white,
            );
          } else {
            context.read<LoginBloc>().add(LoginEvent.loginWithEmail(
                email: emailController.text, password: 'Demo password'));
          }
        },
        child: Text(
          'Continue',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
