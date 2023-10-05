import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class PreviewImage extends StatefulWidget {
   PreviewImage({Key? key,this.image}) : super(key: key);
var image;
  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: PhotoView(
            imageProvider: NetworkImage(widget.image),
            initialScale: PhotoViewComputedScale.contained * 1,
            minScale:  PhotoViewComputedScale.contained * 0.8,maxScale:  PhotoViewComputedScale.contained * 5,
          )
      ),
    );
  }
}
