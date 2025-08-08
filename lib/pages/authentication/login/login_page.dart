// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield_with_icon.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
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
  final TextEditingController usernameController = TextEditingController(
    text: '03332538203',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'Pakistan',
  );

  bool isButtonEnabled = false;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
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

            if (isLoading)
              Container(
                color: Colors.black.withAlpha(50),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(double screenHeight, bool shouldScroll) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('${kLogoFolder}app_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: shouldScroll
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              '${kLogoFolder}ziewnic_vertical_logo.png',
                              height: 150,
                            ),
                            const SizedBox(height: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "LOYALTY",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  "PROGRAM",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 37,
                                      height: 0.9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            CustomInputFieldWithIcon(
                              controller: usernameController,
                              hintText: 'Username',
                              imageAssetPath: '${kIconFolder}user_icon.png',
                            ),
                            const SizedBox(height: 20),
                            CustomInputFieldWithIcon(
                              controller: passwordController,
                              hintText: 'Password',
                              imageAssetPath: '${kIconFolder}lock_icon.png',
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() => rememberMe = value!);
                                  },
                                  activeColor: kPrimaryColor,
                                  checkColor: Colors.white,
                                ),
                                Text(
                                  "Remember me",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: kDefaultTextFieldColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomPrimaryButton(
                              text: 'Login',
                              isDisabled: isButtonEnabled,
                              onPressed: isButtonEnabled
                                  ? () async {
                                      login();
                                    }
                                  : null,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don’t have account?",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "REGISTER NOW",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "UAN ",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "021 111 000 666  |  www.ziewnic.com",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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
        await UserPrefsService.saveUser(user);
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
