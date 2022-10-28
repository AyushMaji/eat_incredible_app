import 'package:eat_incredible_app/repo/login_repo.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/others/account/about_page.dart';
import 'package:eat_incredible_app/views/home_page/others/account/account_info_page.dart';
import 'package:eat_incredible_app/views/home_page/others/account/faqs_page.dart';
import 'package:eat_incredible_app/views/home_page/others/my_address/my_address_page.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcountPage extends StatefulWidget {
  const AcountPage({super.key});

  @override
  State<AcountPage> createState() => _AcountPageState();
}

class _AcountPageState extends State<AcountPage> {
  bool isGuest = true;

  @override
  void initState() {
    super.initState();
    checkGuest();
  }

  Future<void> checkGuest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      setState(() {
        isGuest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.5.w),
        child: ListView(
          children: [
            Visibility(
              visible: isGuest,
              child: ListTile(
                title: Text('Account Info',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                    )),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15.sp,
                ),
                onTap: () => Get.to(() => const AccountInfoPage()),
              ),
            ),
            Visibility(
              visible: isGuest,
              child: const Divider(
                thickness: 1.5,
              ),
            ),
            Visibility(
              visible: isGuest,
              child: ListTile(
                title: Text('Addresses',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                    )),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
                onTap: () => Get.to(() => const MyAddressPage()),
              ),
            ),
            Visibility(
              visible: isGuest,
              child: const Divider(
                thickness: 1.5,
              ),
            ),
            Visibility(
              visible: isGuest,
              child: ListTile(
                title: Text('Payment methods',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                    )),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
                onTap: () {},
              ),
            ),
            Visibility(
              visible: isGuest,
              child: const Divider(
                thickness: 1.5,
              ),
            ),
            ListTile(
              title: Text('About',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                  )),
              trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
              onTap: () => Get.to(() => const AboutPage()),
            ),
            const Divider(
              thickness: 1.5,
            ),
            ListTile(
              title: Text('FAQs',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                  )),
              trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
              onTap: () => Get.to(() => const FaqsPage()),
            ),
            const Divider(
              thickness: 1.5,
            ),
            ListTile(
              title: Text('chats',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                  )),
              trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
              onTap: () {},
            ),
            const Divider(
              thickness: 1.5,
            ),
            ListTile(
              title: Text('Rate The App',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                  )),
              trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
              onTap: () {},
            ),
            const Divider(
              thickness: 1.5,
            ),
            ListTile(
              title: Text('Share Application.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                  )),
              trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
              onTap: () {},
            ),
            const Divider(
              thickness: 1.5,
            ),
            Visibility(
              visible: isGuest,
              child: ListTile(
                title: Text('Log Out',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                    )),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // final SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // final String? phone = prefs.getString('phone');
                            LoginRepo().logout();
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: isGuest,
              child: const Divider(
                thickness: 1.5,
              ),
            ),
            Visibility(
              visible: !isGuest,
              child: ListTile(
                title: Text('Log In',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                    )),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Log In / Sign Up'),
                      content: const Text(
                          'You need to log in or sign up to access all features.'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Get.to(() => const SignupPage());
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: !isGuest,
              child: const Divider(
                thickness: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
