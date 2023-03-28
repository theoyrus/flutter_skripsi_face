import 'package:flutter/material.dart';
import 'package:theoyrus_skripsi_face/presentation/widgets/imageShow.widget.dart';

class ListViewSliderWidget extends StatelessWidget {
  final List<String> images;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ListViewSliderWidget({
    required this.images,
    required this.width,
    required this.height,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                var image = images[index];
                return InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (_) => ImageShowWidget(pathOrUrl: image)),
                  child: Container(
                    margin: margin ?? const EdgeInsets.only(left: 20),
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black12,
                      image: DecorationImage(
                        image: provideImage(context, image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
