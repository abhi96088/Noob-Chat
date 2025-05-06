import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noob_chat/utils/app_colors.dart';

class CustomText{

  static Text titleText ({required String text, Color? color}){
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.primaryColor,
      ),
    );
  }

  static Text labelText ({required String text, Color? color, double? fontSize}){
    return Text(
        text,
        style: GoogleFonts.nunito(
        fontSize: fontSize ?? 18,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
        )
    );
  }

  static Text paragraph ({required String text, Color? color}){
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black,
      ),
    );
  }
}