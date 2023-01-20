import 'package:eat_incredible_app/controller/orderlist/orderlist_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/views/home_page/others/order_view/order_view.dart';
import 'package:eat_incredible_app/widgets/order/order_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () {
          context.read<OrderlistBloc>().add(const OrderlistEvent.orderList());
          return Future.value();
        },
        child: BlocConsumer<OrderlistBloc, OrderlistState>(
          bloc: BlocProvider.of<OrderlistBloc>(context),
          listener: (context, state) {
            state.when(
                initial: () {},
                loading: () {},
                loaded: (_) {},
                failure: (e) {
                  CustomSnackbar.flutterSnackbar(e.toString(), context);
                });
          },
          builder: (context, state) {
            return state.maybeWhen(
                orElse: () {
                  return Center(
                    child: TextButton.icon(
                      onPressed: () {
                        context
                            .read<OrderlistBloc>()
                            .add(const OrderlistEvent.orderList());
                      },
                      icon: const Icon(Icons.refresh_outlined),
                      label: const Text(
                        "Retry",
                        style:
                            TextStyle(color: Color.fromARGB(138, 17, 16, 16)),
                      ),
                    ),
                  );
                },
                loading: (() => const LinearProgressIndicator(
                      color: Colors.red,
                      backgroundColor: Color.fromARGB(76, 244, 67, 54),
                    )),
                loaded: (orderlist) {
                  return orderlist.isEmpty
                      ? Center(
                          child: Text("No orders yet",
                              style: TextStyle(
                                  color: const Color.fromARGB(40, 0, 0, 0),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500)))
                      : AnimationLimiter(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: orderlist.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 600),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 2.5.h),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: OrderCard(
                                        image: 'assets/images/food.png',
                                        orderId: orderlist[index]
                                            .odrNumber
                                            .toString(),
                                        orderDate: orderlist[index]
                                            .placedOn
                                            .toString(),
                                        orderStatus: orderlist[index]
                                            .orderStatus
                                            .toString(),
                                        orderTotal: orderlist[index]
                                            .totalAmount
                                            .toString(),
                                        orderQuantity: orderlist[index]
                                                    .totalItems ==
                                                1
                                            ? "1 item"
                                            : "${orderlist[index].totalItems} items",
                                        viewDetails: () {
                                          Get.to(() => OrderViewPage(
                                              id: orderlist[index]
                                                  .id
                                                  .toString(),
                                              oid: orderlist[index]
                                                  .odrNumber
                                                  .toString()));
                                        },
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        );
                });
          },
        ),
      ),
    );
  }
}
