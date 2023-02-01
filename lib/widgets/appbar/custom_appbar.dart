import 'package:dio/dio.dart';
import 'package:eat_incredible_app/controller/cart/cart_details/cart_details_bloc.dart';
import 'package:eat_incredible_app/controller/category/category_bloc.dart';
import 'package:eat_incredible_app/controller/product_list/product_list_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/Item_search/item_search.dart';
import 'package:eat_incredible_app/views/home_page/others/cart_page/cart_page.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart' as badges;

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  final ProductListBloc productListBloc = ProductListBloc();
  List items = [];
  final TextEditingController zipcontroller = TextEditingController();
  String? location;

  @override
  void initState() {
    checkLocation();
    getData();
    super.initState();
  }

  checkLocation() async {
    //  get permition of location
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    } else {
      // Position position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
      // final List<Placemark> placemarks =
      //     await placemarkFromCoordinates(position.latitude, position.longitude);
      // final Placemark place = placemarks[0];
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      location = prefs.getString('location') ?? 'Select Location';
      zipcontroller.text = prefs.getString('pincode') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/appbar.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 35.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 50.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Select City",
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: SizedBox(
                                      child: FindDropdown(
                                        showSearchBox: false,
                                        onFind: (String filter) async {
                                          var response = await Dio().get(
                                            "https://eatincredible.in/api/location.php",
                                            queryParameters: {
                                              "location": filter
                                            },
                                          );
                                          List locationList = [];
                                          for (var item in response.data) {
                                            locationList.add(item["location"]);
                                            items.add({
                                              "location": item["location"],
                                              "pincode": item["pincode"]
                                            });
                                          }
                                          return locationList;
                                        },
                                        onChanged: (value) {
                                          for (var item in items) {
                                            if (item["location"] == value) {
                                              setState(() {
                                                zipcontroller.text =
                                                    item["pincode"].toString();
                                                location = item["location"];
                                              });
                                            }
                                          }
                                        },
                                        label: "",
                                        selectedItem: location,
                                        validate: (i) {
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h),
                                    child: SizedBox(
                                      //height: 43.h,
                                      child: TextFormField(
                                        controller: zipcontroller,
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            // borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: 'Zip Code',
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
                                  const Spacer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h),
                                    child: SizedBox(
                                      height: 46.h,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (zipcontroller.text.isEmpty) {
                                            CustomSnackbar.errorSnackbar(
                                                'Error',
                                                'Please enter zip code');
                                          } else {
                                            Navigator.pop(context);
                                            // store data in shared pref
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                "pincode", zipcontroller.text);
                                            prefs.setString("location",
                                                location.toString());
                                            Logger().i(location);
                                            // ignore: use_build_context_synchronously
                                            context.read<CategoryBloc>().add(
                                                const CategoryEvent
                                                    .getCategory());
                                            productListBloc.add(
                                                const ProductListEvent
                                                        .fetchProductList(
                                                    categoryId: "98989"));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          backgroundColor: const Color.fromRGBO(
                                              226, 10, 19, 1),
                                        ),
                                        child: Text("Apply",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        SizedBox(width: 1.h),
                        Text(
                          zipcontroller.text == ""
                              ? "Select City"
                              : " $location, ${zipcontroller.text}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BlocConsumer<CartDetailsBloc, CartDetailsState>(
                    bloc: context.read<CartDetailsBloc>(),
                    listener: (context, state) {},
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const CartPage());
                            },
                            child: const badges.Badge(
                              showBadge: false,
                              badgeContent: Text(
                                '',
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Icon(Icons.shopping_cart,
                                  color: Colors.white),
                            ),
                          );
                        },
                        loaded: (cartDetailModel) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const CartPage());
                            },
                            child: badges.Badge(
                              showBadge:
                                  cartDetailModel.totalItem == 0 ? false : true,
                              badgeStyle: const badges.BadgeStyle(
                                badgeColor: Colors.green,
                                padding: EdgeInsets.all(4.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              badgeContent: Text(
                                cartDetailModel.totalItem.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                              child: const Icon(Icons.shopping_cart,
                                  color: Colors.white),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      // ignore: deprecated_member_use
                      launch('https://wa.me/9433990099');
                    },
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const ItemSearch());
              },
              child: Container(
                height: 35.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: Text(
                        'Search',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5.sp,
                          color: const Color.fromRGBO(46, 46, 46, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0.w),
                      child: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
