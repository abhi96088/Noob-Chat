import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noob_chat/providers/flag_provider.dart';
import 'package:noob_chat/screens/register_screen.dart';
import 'package:noob_chat/utils/app_colors.dart';
import 'package:noob_chat/widget/custom_buttons.dart';
import 'package:noob_chat/widget/custom_snackbar.dart';
import 'package:noob_chat/widget/custom_textfield.dart';
import 'package:noob_chat/widget/custom_texts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controllers to handle text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ///______________________ Function to handle login ____________________________///
  void handleLogin(FlagProvider provider) async {
    provider.toggleLoading();

    final user = await AuthService().signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    provider.toggleLoading();

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      CustomSnackBar.showSnackBar(
          context: context, message: 'Login failed. Please check credentials.');
    }
  }

  ///______________________ Function to handle login through google ____________________________///
  void handleGoogleLogin(FlagProvider provider) async {
    provider.toggleLoading();

    final user = await AuthService().signInWithGoogle();

    provider.toggleLoading();

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      CustomSnackBar.showSnackBar(
          context: context, message: 'Google Sign-In failed');
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: screenHeight * 0.15,
                    width: screenWidth,
                    child: Image.asset("assets/images/banner.PNG")),
                CustomText.titleText(text: "Login"),
                SizedBox(height: screenHeight * 0.04),
                CustomTextField(
                  controller: emailController,
                  labelText: "Email",
                  icon: Icon(Icons.email),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(
                  controller: passwordController,
                  labelText: "Password",
                  icon: Icon(Icons.lock),
                  isPassword: true,
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomButtons().primaryButton(child: provider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                  : CustomText.labelText(text: "Login"), onPressed: (){
                  handleLogin(provider);
                },),
                SizedBox(height: screenHeight * 0.016),
                CustomText.paragraph(text: "Or"),
                SizedBox(height: screenHeight * 0.016),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                    onPressed: () => handleGoogleLogin(provider),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF2E8BFF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: CustomText.labelText(text: "Continue with Google", color: AppColors.primaryColor
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.016),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                  child: RichText(text: TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Register Now",
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
