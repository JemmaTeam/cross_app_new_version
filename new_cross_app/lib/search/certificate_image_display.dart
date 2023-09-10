import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CertificateDisplay extends StatelessWidget {
  final String imageUrl;

  CertificateDisplay({required this.imageUrl});

  Future<Uint8List?> _loadImage() async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      print('Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _loadImage(),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          print('FutureBuilder error: ${snapshot.error}');
          return Icon(Icons.error);
        } else {
          return Image.memory(snapshot.data!);
        }
      },
    );
  }
}
