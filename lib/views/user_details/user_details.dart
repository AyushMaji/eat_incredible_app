import 'package:eat_incredible_app/controller/inser_name/insername_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetails extends StatefulWidget {
  final String loginType;
  final String value;

  const UserDetails({super.key, required this.loginType, required this.value});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
        height: 60.h,
        width: double.infinity,
        child: BlocConsumer<InsernameBloc, InsernameState>(
          listener: (context, state) {
            state.maybeWhen(
                loaded: (status, msg) {
                  if (status == '200') {
                    CustomSnackbar.successSnackbar('Success', msg);
                    Get.offAll(() => const Navigation());
                  } else {
                    CustomSnackbar.errorSnackbar('Error', msg);
                  }
                },
                orElse: () {});
          },
          builder: (context, state) {
            return state.maybeWhen(loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }, orElse: () {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: const Color.fromRGBO(226, 10, 19, 1),
                  ),
                  onPressed: () async {
                    if (_nameController.text == '' ||
                        _valueController.text == '') {
                      CustomSnackbar.errorSnackbar(
                          'Error', 'Please fill all fields');
                    } else {
                      widget.loginType == 'email'
                          ? context.read<InsernameBloc>().add(
                              InsernameEvent.insertName(
                                  name: _nameController.text,
                                  value: _valueController.text,
                                  loginType: 'phone'))
                          : context.read<InsernameBloc>().add(
                              InsernameEvent.insertName(
                                  name: _nameController.text,
                                  value: _valueController.text,
                                  loginType: 'email'));
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
            });
          },
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(142, 0, 0, 0),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: SizedBox(
                  width: 100.h,
                  height: 100.h,
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    height: 18.h,
                  ),
                  Center(
                    child: Text(
                      'User Details',
                      style: GoogleFonts.poppins(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Center(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: widget.loginType == "email"
                            ? Text(
                                ' Please enter your name and mobile number to continue',
                                style: GoogleFonts.poppins(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        const Color.fromRGBO(165, 165, 165, 1)),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                ' Please enter your name and email to continue',
                                style: GoogleFonts.poppins(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        const Color.fromRGBO(165, 165, 165, 1)),
                                textAlign: TextAlign.center,
                              )),
                  ),
                  SizedBox(
                    height: 29.h,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: SizedBox(
                height: 46.h,
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                ),
              ),
            ),
            widget.loginType == "email"
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: SizedBox(
                      height: 46.h,
                      child: TextFormField(
                        controller: _valueController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Mobile Number',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email can not be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: SizedBox(
                      height: 46.h,
                      child: TextFormField(
                        controller: _valueController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Email Address',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email Address";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
