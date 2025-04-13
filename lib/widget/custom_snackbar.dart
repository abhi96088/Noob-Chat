import 'package:flutter/material.dart';

class CustomSnackBar{

  static void showSnackBar({required BuildContext context, required String message}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}