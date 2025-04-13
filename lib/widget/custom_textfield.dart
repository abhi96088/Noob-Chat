import 'package:flutter/material.dart';
import 'package:noob_chat/providers/flag_provider.dart';
import 'package:noob_chat/utils/app_colors.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final String labelText;
  final Icon? icon;
  final bool? isPassword;

  const CustomTextField({super.key, required this.controller, required this.labelText, this.icon, this.isPassword});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FlagProvider>();

    return TextField(
      controller: controller,
      obscureText: provider.isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2)
        ),
        prefixIcon: icon,
        suffixIcon: isPassword == true ? IconButton(onPressed: (){provider.toggleVisibility();}, icon: provider.isVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off)) : null
      ),
    );
  }
}
