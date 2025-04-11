import "package:flutter/material.dart";
import "package:flutter/services.dart";

Future<ImageProvider> fetchProfileImage(String id) async {
  final String imagePath = 'assets/user-profile/$id.png';
  try {
    await rootBundle.load(imagePath);
    return AssetImage(imagePath);
  } catch (e) {
    return AssetImage('assets/user-profile/default.png');
  }
}