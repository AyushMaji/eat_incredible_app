import 'dart:async';
import 'dart:developer';

import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/navigation/navigation.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
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
    // _controller.addListener(() {
    //   if (_controller.value.position == _controller.value.duration) {
    //     Get.off(() => const SignupPage());
    //   }
    // });

    Timer(const Duration(milliseconds: 3300), () {
      checkRoute();
    });

    super.initState();
  }

  void checkRoute() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? guestId = prefs.getString('guest_id');
    log('token: $token');
    log('guestId: $guestId');
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
                child: Container(
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ));
  }
}
