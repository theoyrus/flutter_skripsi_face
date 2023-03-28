import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

import '../../env/env.dart';
import '../../utils/string.utils.dart';

class ImageShowWidget extends StatelessWidget {
  final String pathOrUrl;
  const ImageShowWidget({required this.pathOrUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Column(
          children: [
            if (isStringUrl(pathOrUrl))
              Expanded(child: imageNetCachedLoad(context, pathOrUrl)),
            if (isValidPath(pathOrUrl)) Expanded(child: imageLocal(pathOrUrl)),
          ],
        ),
      ),
    );
  }
}

CachedNetworkImage imageNetCachedLoad(context, url) {
  return CachedNetworkImage(
    imageUrl: url,
    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
      child: Center(
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
        ),
      ),
    ),
  );
}

Image imageLocal(path) {
  var imageF = File(path);
  if (!isRelease) {
    debugPrint(
        '====> ukuran image: ${(imageF.lengthSync() / 1024).toString()} KB');
    final bytes = imageF.readAsBytesSync();
    final image = imglib.decodeImage(bytes);
    if (image != null) {
      final width = image.width;
      final height = image.height;
      debugPrint('====> Width: $width, Height: $height');
    }
  }
  return Image.file(
    imageF,
    fit: BoxFit.scaleDown,
  );
}

ImageProvider provideImage(BuildContext context, String pathOrUrl) {
  if (isStringUrl(pathOrUrl)) {
    return CachedNetworkImageProvider(pathOrUrl);
  } else if (isValidPath(pathOrUrl)) {
    return FileImage(File(pathOrUrl));
  }
  throw ArgumentError('Invalid path or URL provided: $pathOrUrl');
}
