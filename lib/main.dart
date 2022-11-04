import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_incredible_app/controller/address/addaddress/addaddress_bloc.dart';
import 'package:eat_incredible_app/controller/address/view_address_list/view_addresslist_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/cart/cart_iteam/cart_iteams_bloc.dart';
import 'package:eat_incredible_app/controller/category/category_bloc.dart';
import 'package:eat_incredible_app/controller/login/login_bloc.dart';
import 'package:eat_incredible_app/controller/product_details/product_details_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/controller/update_userdata/update_user_data/update_user_bloc.dart';
import 'package:eat_incredible_app/controller/update_userdata/verify_user_data/up_verrify_data_bloc.dart';
import 'package:eat_incredible_app/controller/user_info/user_info_bloc.dart';
import 'package:eat_incredible_app/controller/verify_otp/verify_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/splash_screen/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBloc>(create: (context) => CategoryBloc()),
              BlocProvider<ProductListBloc>(
                  create: (context) => ProductListBloc()),
              BlocProvider<ProductDetailsBloc>(
                  create: (context) => ProductDetailsBloc()),
              BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
              BlocProvider<VerifyBloc>(create: (context) => VerifyBloc()),
              BlocProvider<CartBloc>(create: (context) => CartBloc()),
              BlocProvider<UserInfoBloc>(create: (context) => UserInfoBloc()),
              BlocProvider<UpdateUserBloc>(
                  create: (context) => UpdateUserBloc()),
              BlocProvider<UpVerrifyDataBloc>(
                  create: (context) => UpVerrifyDataBloc()),
              BlocProvider<CartDetailsBloc>(
                  create: (context) => CartDetailsBloc()),
              BlocProvider<CartIteamsBloc>(
                  create: (context) => CartIteamsBloc()),
              BlocProvider<AddaddressBloc>(
                  create: (context) => AddaddressBloc()),
              BlocProvider<ViewAddresslistBloc>(
                  create: (context) => ViewAddresslistBloc()),
            ],
            child: GetMaterialApp(
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              theme: ThemeData(useMaterial3: true),
              debugShowCheckedModeBanner: false,
              title: 'Eat incredible App',
              home: const SplashScreen(),
            ),
          );
        });
  }
}
