import 'package:cached_network_image/cached_network_image.dart';
import 'package:eat_incredible_app/utils/barrel.dart';
import 'package:shimmer/shimmer.dart';

class CustomPic extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  const CustomPic(
      {super.key,
      required this.imageUrl,
      required this.height,
      required this.width,
      required this.fit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
            child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width,
            height: height,
            color: const Color.fromARGB(68, 241, 237, 237),
          ),
        )),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          size: 30,
        ),
      ),
    );
  }
}
