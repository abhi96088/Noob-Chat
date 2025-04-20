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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CustomText.titleText(
                  text: 'Create Account',
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: emailController,
                  labelText: "Email",
                  icon: Icon(Icons.email),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: nameController,
                  labelText: "Name",
                  icon: Icon(Icons.person),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  labelText: "Password",
                  icon: Icon(Icons.lock),
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: confirmController,
                  labelText: "Confirm Password",
                  icon: Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 30),
                CustomButtons().primaryButton(
                    onPressed: () => handleRegister(provider),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : CustomText.labelText(text: "Register")),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: CustomText.paragraph(text: 'Already have an account? Login', color: AppColors.primaryColor)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
