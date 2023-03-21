import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
          width: 90.pw(size),
          height: 90.ph(size),
          child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child:PhotoView(
                    maxScale: 1.5,
                    tightMode: true,
                    customSize: Size(60.pw(size),60.ph(size)),
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,

                    ),
                    imageProvider: const AssetImage("assets/images/organize.png"),
                  ),
                ),
                Align(
                    alignment: const Alignment(0.85,-0.90),
                    child: IconButton(icon: const Icon(Icons.clear,color: Colors.white), onPressed: () {
                      Navigator.pop(context);
                    },)),

              ]
          )
      ),
    );
  }
}
