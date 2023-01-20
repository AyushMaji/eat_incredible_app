import 'package:eat_incredible_app/controller/about/about_bloc.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:eat_incredible_app/utils/messsenger.dart';
import 'package:eat_incredible_app/widgets/faq_card/faq_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({super.key});

  @override
  State<FaqsPage> createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  @override
  void initState() {
    context.read<AboutBloc>().add(const AboutEvent.aboutUs());
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
            'About Us',
            style: GoogleFonts.poppins(
              color: const Color.fromRGBO(97, 97, 97, 1),
              fontSize: 13.sp,
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
          context.read<AboutBloc>().add(const AboutEvent.aboutUs());
        },
        child: BlocConsumer<AboutBloc, AboutState>(
          bloc: context.read<AboutBloc>(),
          listener: (context, state) {
            state.when(
                initial: () {},
                loading: () {},
                loaded: (_) {},
                error: (e) {
                  CustomSnackbar.flutterSnackbar(e.toString(), context);
                });
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: (() {
                return Center(
                  child: TextButton.icon(
                    onPressed: () {
                      context.read<AboutBloc>().add(const AboutEvent.aboutUs());
                    },
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text(
                      "Retry",
                      style: TextStyle(color: Color.fromARGB(138, 17, 16, 16)),
                    ),
                  ),
                );
              }),
              loaded: ((aboutModel) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 18.w, bottom: 10.h, top: 2.h),
                        child: Text("About Us",
                            style: GoogleFonts.poppins(
                                fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 18.w, bottom: 20.h, right: 18.w),
                        child: Text(
                          aboutModel.about,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(97, 97, 97, 1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18.w, bottom: 1.h),
                        child: Text("FAQs",
                            style: GoogleFonts.poppins(
                                fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      ),
                      FaqCard(
                          description: "Our Mission",
                          title: aboutModel.ourMission),
                      FaqCard(
                          description: "Our Vision",
                          title: aboutModel.ourVision),
                      FaqCard(
                          description: "why you choose us",
                          title: aboutModel.whyChooseUs),
                      FaqCard(
                          description: "Our Founders",
                          title: aboutModel.ourFounders)
                    ],
                  ),
                );
              }),
              loading: () {
                return const LinearProgressIndicator(
                  color: Colors.red,
                  backgroundColor: Color.fromARGB(60, 244, 67, 54),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
