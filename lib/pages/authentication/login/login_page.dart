// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/models/force_update.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/application/homescreen.dart';
import 'package:loyalty_program/pages/authentication/forget_password/forget_password_page.dart';
import 'package:loyalty_program/pages/authentication/registration/registration_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // Wait for widget to be fully mounted before calling API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      force_update_check();
    });
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
                hintText: "Enter your Mobile Number",
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
          MaterialPageRoute(builder: (_) => const HomeScreen()),
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

  void force_update_check() async {
    try {
      final api = ApiService();

      final request = await api.request(
        path: "${ForeceUpdate}1.0.0",
        type: RequestType.post,
        data: {},
        useFormData: false,
      );

      if (!mounted) return;

      // Handle case where response.data might be a String or Map
      dynamic jsonData = request.data;
      Map<String, dynamic> json;

      if (jsonData is String) {
        // If it's a string, parse it as JSON
        json = jsonDecode(jsonData) as Map<String, dynamic>;
      } else if (jsonData is Map<String, dynamic>) {
        // If it's already a Map, use it directly
        json = jsonData;
      } else {
        // Fallback: try to convert to Map
        json = jsonData as Map<String, dynamic>;
      }

      final response = ForeceUpdateModel.fromJson(json);

      if (response.isForce) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Force Update"),
            content: const Text(
              "New version is available. Please update to the latest version.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _openAppStore(
                    iosUrl: response.iosurl,
                    androidUrl: response.androidurl,
                  );
                },
                child: Text(
                  "Update",
                  style: GoogleFonts.inter(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Silently handle errors - don't show error dialog for force update check
      print('Force update check error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _openAppStore({
    required String iosUrl,
    required String androidUrl,
  }) async {
    String url;

    if (Platform.isIOS) {
      url = iosUrl.isNotEmpty ? iosUrl : '';
    } else if (Platform.isAndroid) {
      url = androidUrl.isNotEmpty ? androidUrl : '';
    } else {
      return;
    }

    if (url.isEmpty) {
      return;
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
