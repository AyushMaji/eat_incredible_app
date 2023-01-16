import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/address/addaddress/addaddress_bloc.dart';
import 'package:eat_incredible_app/controller/address/view_address_list/view_addresslist_bloc.dart';
import 'package:eat_incredible_app/controller/user_info/user_info_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    BotToast.showLoading();
    final Position position = await determinePosition();
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final Placemark place = placemarks[0];
    localityController.text = " ${place.name}, ${place.street!} ";
    cityController.text = place.locality!;
    landmarkController.text = place.subLocality!;
    pincodeController.text = place.postalCode!;
    locationController.text = place.administrativeArea!;
    Logger().i(place);
    BotToast.closeAllLoading();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
          child: SizedBox(
            height: 40.h,
            child: BlocConsumer<AddaddressBloc, AddaddressState>(
              listener: (context, state) {
                state.when(
                    initial: () {},
                    loading: () {},
                    success: () {
                      Get.back();
                      CustomSnackbar.successSnackbar(
                          "success", "Address added successfully");
                      context
                          .read<ViewAddresslistBloc>()
                          .add(const ViewAddresslistEvent.getAddressList());
                      context
                          .read<UserInfoBloc>()
                          .add(const UserInfoEvent.getUserInfo());
                    },
                    failure: (error) {
                      CustomSnackbar.errorSnackbar("error", error);
                    });
              },
              builder: (context, state) {
                return state.maybeWhen(
                  loading: (() => const Center(
                        child: CircularProgressIndicator(),
                      )),
                  orElse: () {
                    return ElevatedButton(
                      onPressed: () {
                        if (localityController.text.isNotEmpty &&
                            cityController.text.isNotEmpty &&
                            pincodeController.text.isNotEmpty &&
                            locationController.text.isNotEmpty &&
                            landmarkController.text.isNotEmpty) {
                          addressController.text =
                              "${localityController.text}, ${landmarkController.text}, ${cityController.text}, ${pincodeController.text}, ${locationController.text} ";

                          context
                              .read<AddaddressBloc>()
                              .add(AddaddressEvent.addAddress(
                                address: addressController.text,
                                city: cityController.text,
                                state: locationController.text,
                                pincode: pincodeController.text,
                                landmark: landmarkController.text,
                                locality: localityController.text,
                                location: locationController.text,
                              ));
                        } else {
                          CustomSnackbar.errorSnackbar(
                              "error", "Please fill all the fields");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE20A13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.sp),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Color.fromRGBO(0, 0, 0, 1)),
            onPressed: () => Get.back(),
          ),
          title: Center(
            child: Text(
              'Add Address',
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
                icon:
                    const Icon(Icons.search, color: Color.fromRGBO(0, 0, 0, 1)),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: ListView(
              children: [
                ListTile(
                  onTap: getCurrentLocation,
                  leading: const Icon(
                    Icons.my_location,
                    color: Color.fromRGBO(226, 10, 19, 1),
                  ),
                  title: Text(
                    'Use current location',
                    style: TextStyle(
                      color: const Color.fromRGBO(97, 97, 97, 1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    'Use your current location to find nearby food and restaurants around you',
                    style: TextStyle(
                      color: const Color.fromRGBO(97, 97, 97, 1),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: localityController,
                  decoration: InputDecoration(
                    hintText: 'HOUSE / FLAT / BLOCK NO.',
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromRGBO(97, 97, 97, 1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCFCFCF),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE20A13)),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: landmarkController,
                  decoration: InputDecoration(
                    hintText: 'LANDMARK',
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromRGBO(97, 97, 97, 1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCFCFCF),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE20A13)),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: pincodeController,
                  decoration: InputDecoration(
                    hintText: 'pincode',
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromRGBO(97, 97, 97, 1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCFCFCF),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE20A13)),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: 'CITY',
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromRGBO(97, 97, 97, 1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCFCFCF),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE20A13)),
                    ),
                  ),
                ),
                SizedBox(height: 19.h),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'LOCATION',
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromRGBO(97, 97, 97, 1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCFCFCF),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE20A13)),
                    ),
                  ),
                ),
                SizedBox(height: 19.h),
                // Text("Save As",
                //     style: GoogleFonts.poppins(
                //       color: const Color.fromRGBO(97, 97, 97, 1),
                //       fontSize: 13.sp,
                //       fontWeight: FontWeight.w500,
                //     )),
                // SizedBox(height: 25.h),
                // AddressChips(
                //   onSelected: (String value) {
                //     log(value);
                //   },
                // )
              ],
            )));
  }
}
