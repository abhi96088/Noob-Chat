import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noob_chat/providers/flag_provider.dart';
import 'package:noob_chat/screens/login_screen.dart';
import 'package:noob_chat/utils/app_colors.dart';
import 'package:noob_chat/widget/custom_buttons.dart';
import 'package:noob_chat/widget/custom_snackbar.dart';
import 'package:noob_chat/widget/custom_textfield.dart';
import 'package:noob_chat/widget/custom_texts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // controllers to handle text inside text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  ///______________________ Function to handle user registration ____________________________///
  void handleRegister(FlagProvider provider) async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (password != confirm) {
      CustomSnackBar.showSnackBar(
          context: context, message: 'Passwords do not match');
      return;
    }

    provider.toggleLoading();

    final user = await AuthService().register(email, password, name);

    provider.toggleLoading();

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      CustomSnackBar.showSnackBar(
          context: context, message: 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FlagProvider>();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                    height: screenHeight * 0.15,
                    width: screenWidth,
                    child: Image.asset("assets/images/banner.PNG")),
                CustomText.titleText(
                  text: 'Create Account',
                ),
                SizedBox(height: screenHeight * 0.04),
                CustomTextField(
                  controller: emailController,
                  labelText: "Email",
                  icon: Icon(Icons.email),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(
                  controller: nameController,
                  labelText: "Name",
                  icon: Icon(Icons.person),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(
                  controller: passwordController,
                  labelText: "Password",
                  icon: Icon(Icons.lock),
                  isPassword: true,
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(
                  controller: confirmController,
                  labelText: "Confirm Password",
                  icon: Icon(Icons.lock_outline),
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomButtons().primaryButton(
                    onPressed: () => handleRegister(provider),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : CustomText.labelText(text: "Register")),
                SizedBox(height: screenHeight * 0.016),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                    child: RichText(text: TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:Colors.black,
                        ),
                        children: [
                          TextSpan(text: "Login",
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),)
                        ]
                    ),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
