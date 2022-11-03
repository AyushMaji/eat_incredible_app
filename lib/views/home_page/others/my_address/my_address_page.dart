import 'package:eat_incredible_app/controller/address/view_address_list.dart/view_addresslist_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/views/home_page/others/add_address/add_address_page.dart';
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
    context
        .read<ViewAddresslistBloc>()
        .add(const ViewAddresslistEvent.getAddressList());

    super.initState();
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                  return const Center(child: CircularProgressIndicator());
                }, loaded: (addressList) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 13.w, vertical: 8.h),
                        child: AddressCard(
                          address: addressList[index].address.toString(),
                          name: addressList[index].locality.toString(),
                          onDelete: () {},
                          onEdit: () {},
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
    );
  }
}
