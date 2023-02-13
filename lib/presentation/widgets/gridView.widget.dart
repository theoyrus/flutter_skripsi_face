import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/string.utils.dart';
import 'longText.widget.dart';

class ImageItem {
  final String image;
  final String name;
  final Map<String, dynamic>? data;
  ImageItem(this.image, this.name, [this.data]);
}

class GridViewWidget extends StatelessWidget {
  final List<ImageItem> items;
  final int crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onDoubleTap;

  final ScrollController? scrollController;

  const GridViewWidget(
      {Key? key,
      required this.items,
      required this.crossAxisCount,
      this.mainAxisSpacing,
      this.crossAxisSpacing,
      this.onTap,
      this.onDoubleTap,
      this.scrollController})
      : super(key: key);

  static List<ImageItem> sampleItems = [
    ImageItem(
        "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=150&w=150",
        "Stephan Seeber"),
    ImageItem(
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=150&w=150",
        "Liam Gant"),
    ImageItem(
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=150&w=150",
        "Liam Gant"),
    ImageItem(
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=150&w=150",
        "Liam Gant"),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing ?? 0,
        crossAxisSpacing: crossAxisSpacing ?? 0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ImageCardWidget(
          index: index,
          item: items[index],
          onTap: onTap,
          onDoubleTap: onDoubleTap,
        );
      },
    );
  }
}

class ImageCardWidget extends StatelessWidget {
  final int index;
  final ImageItem item;
  // final Function? onTap;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onDoubleTap;

  const ImageCardWidget({
    Key? key,
    required this.index,
    required this.item,
    this.onTap,
    this.onDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!(index);
      },
      onDoubleTap: () {
        onDoubleTap!(index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (isStringUrl(item.image)) Expanded(child: ImageNetworkLoading()),
          if (isStringUrl(item.image))
            Expanded(child: ImageNetCachedLoad(context)),
          if (isValidPath(item.image)) Expanded(child: ImageLocal()),
          LongText(
            text: item.name,
            textOverflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Image ImageNetworkLoading() {
    return Image.network(
      item.image,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return child;
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  CachedNetworkImage ImageNetCachedLoad(context) {
    return CachedNetworkImage(
      imageUrl: item.image,
      height: 120.0,
      width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
        margin: const EdgeInsets.only(top: 100, bottom: 100),
        child: Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        ),
      ),
    );
  }

  Image ImageLocal() {
    return Image.file(
      File(item.image),
      fit: BoxFit.cover,
    );
  }

  Widget ImageBox() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(item.image),
        ),
      ),
    );
  }
}
