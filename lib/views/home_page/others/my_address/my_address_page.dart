import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/controller/address/view_address_list/view_addresslist_bloc.dart';
import 'package:eat_incredible_app/controller/user_info/user_info_bloc.dart';
import 'package:eat_incredible_app/repo/address_repo.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/add_address/add_address_page.dart';
import 'package:eat_incredible_app/views/home_page/others/edit_address/edit_address_page.dart';
import 'package:eat_incredible_app/widgets/address_card/address_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    context
        .read<ViewAddresslistBloc>()
        .add(const ViewAddresslistEvent.getAddressList());
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
            'My Address',
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
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
          return Future.value();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  Get.to(() => const AddAddressPage());
                },
                icon: const Icon(Icons.add, color: Color(0xffE20A13)),
                label: Text('Add new address',
                    style: TextStyle(
                      color: const Color(0xff000000),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              SizedBox(height: 5.h),
              BlocConsumer<ViewAddresslistBloc, ViewAddresslistState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return state.maybeWhen(orElse: () {
                    return const Text('something went wrong');
                  }, loading: () {
                    return const Center(
                        child: LinearProgressIndicator(
                      color: Color(0xffE20A13),
                      backgroundColor: Color.fromARGB(72, 226, 10, 17),
                    ));
                  }, loaded: (addressList) {
                    return addressList.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 120.h),
                            child: Center(
                              child: Text('No address found',
                                  style: TextStyle(
                                    color: const Color.fromARGB(47, 0, 0, 0),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: addressList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13.w, vertical: 8.h),
                                child: AddressCard(
                                  address:
                                      addressList[index].address.toString(),
                                  name: addressList[index].locality.toString(),
                                  onDelete: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Delete Address'),
                                            content: const Text(
                                                'Are you sure you want to delete this address?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  BotToast.showLoading();
                                                  var result = await AddressRepo()
                                                      .deleteaddress(
                                                          addressId:
                                                              addressList[index]
                                                                  .id
                                                                  .toString());
                                                  result.when(success: (value) {
                                                    CustomSnackbar.successSnackbar(
                                                        'Success',
                                                        'Address deleted successfully');
                                                    getData();
                                                    context
                                                        .read<UserInfoBloc>()
                                                        .add(const UserInfoEvent
                                                            .getUserInfo());
                                                    Navigator.pop(context);
                                                    BotToast.closeAllLoading();
                                                  }, failure: (error) {
                                                    CustomSnackbar
                                                        .errorSnackbar(
                                                            'Error', '$error');
                                                    Navigator.pop(context);
                                                    BotToast.closeAllLoading();
                                                  });
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  onEdit: () {
                                    Get.to(() => EditAddressPage(
                                          addressId:
                                              addressList[index].id.toString(),
                                          address: addressList[index]
                                              .address
                                              .toString(),
                                          city: addressList[index]
                                              .city
                                              .toString(),
                                          state: addressList[index]
                                              .location
                                              .toString(),
                                          pincode: addressList[index]
                                              .pincode
                                              .toString(),
                                          locality: addressList[index]
                                              .locality
                                              .toString(),
                                          landmark: addressList[index]
                                              .landmark
                                              .toString(),
                                        ));
                                  },
                                ),
                              );
                            },
                          );
                  }, error: (message) {
                    return Center(
                      child: Text(message),
                    );
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
