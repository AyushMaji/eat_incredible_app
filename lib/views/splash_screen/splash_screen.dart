import 'dart:async';

import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/navigation/navigation.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
import 'package:logger/logger.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/images/animation.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);
        _controller.setPlaybackSpeed(1.0);
        setState(() {});
      });

    Timer(const Duration(milliseconds: 3740), () {
      checkRoute();
    });

    super.initState();
  }

  void checkRoute() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? guestId = prefs.getString('guest_id');
    Logger().i("token $token");
    Logger().i("guestid $guestId");
    if (token != null || guestId != null) {
      Get.off(() => const Navigation());
    } else {
      Get.off(() => const SignupPage());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: const RiveAnimation.asset(
                  'assets/images/logo_animation.riv',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ));
  }
}
