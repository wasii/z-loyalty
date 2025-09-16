// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield_with_icon.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/authentication/forget_password/forget_password_page.dart';
import 'package:loyalty_program/pages/authentication/registration/registration_page.dart';
import 'package:loyalty_program/pages/dashboard/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isButtonEnabled = false;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    _updateButtonState();
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          usernameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final shouldScroll = screenHeight < 700;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _buildMainContent(screenHeight, shouldScroll),

            if (isLoading) Loader(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(double screenHeight, bool shouldScroll) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo aur Loyalty Program text
              AuthenticationHeader(),
              AuthenticationHeaderText(
                title: 'Log in',
                subtitle:
                    'Log in and shine with rewards that brighten your day',
              ),
              // Username field
              AppTextField(
                controller: usernameController,
                hintText: "Enter your username",
                prefixImage: "iconusername.png",
              ),
              const SizedBox(height: 16),

              // Password field
              AppTextField(
                controller: passwordController,
                hintText: "Enter your password",
                prefixImage: "iconpassword.png",
                isPassword: true,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: kPrimaryColor,
                        onChanged: (val) {
                          setState(() {
                            rememberMe = val ?? false;
                          });
                        },
                      ),
                      Text(
                        "Remember me",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // 👈 Medium
                          color: kTextFieldPlaceholderColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgetPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot password?",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Login button
              PrimaryButton(
                text: 'Login',
                onPressed: () {
                  login();
                },
                enabled: isButtonEnabled,
              ),
              const SizedBox(height: 24),
              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Register Now tapped!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegistrationPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Register Now",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();

      final response = await api.request(
        path: LoginAPI,
        type: RequestType.post,
        data: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
        useFormData: true,
      );

      final json = response.data;
      final user = UserModel.fromJson(json);

      usernameController.text = '';
      passwordController.text = '';
      if (user.error == 0) {
        // Successful login
        await UserPrefsService.saveUser(user, rememberMe: rememberMe);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Login Failed"),
            content: Text(user.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
