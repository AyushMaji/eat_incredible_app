import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/utils/barrel.dart';

class CustomSnackbar {
  static errorSnackbar(String title, String subtitle) => Get.snackbar(
        title,
        subtitle,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.only(bottom: 60.h, left: 9.w, right: 9.w),
      );
  static successSnackbar(String title, String subtitle) => Get.snackbar(
        title,
        subtitle,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.only(bottom: 60.h, left: 9.w, right: 9.w),
      );
  static flutterSnackbarWithAction(String title, String actionTitle,
          Function() onPressed, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(title),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          backgroundColor: const Color.fromARGB(255, 29, 30, 29),
          behavior: SnackBarBehavior.fixed,
          action: SnackBarAction(
            label: actionTitle,
            onPressed: onPressed,
          ),
        ),
      );
  static flutterSnackbar(String title, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(title),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          backgroundColor: const Color.fromARGB(255, 29, 30, 29),
          behavior: SnackBarBehavior.fixed,
        ),
      );

  static loading() => BotToast.showLoading(
      clickClose: true,
      allowClick: true,
      crossPage: true,
      backButtonBehavior: BackButtonBehavior.close,
      backgroundColor: Colors.black.withOpacity(0.5),
      duration: const Duration(milliseconds: 500));
}
