// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/authentication_header.dart';
import 'package:loyalty_program/components/authentication_header_text.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_otp_fields.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/models/check_username_model.dart';
import 'package:loyalty_program/models/send_otp_model.dart';
import 'package:loyalty_program/models/user_registration_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/pages/authentication/registration_successful/registration_successful.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController experienceInYearsController =
      TextEditingController();
  //VISITING CARD PICTURE
  final TextEditingController addressController = TextEditingController();
  final TextEditingController easyPaisaController = TextEditingController();
  final TextEditingController jazzCashController = TextEditingController();
  final TextEditingController bankDetailsController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  bool isButtonEnabled = false;
  bool rememberMe = false;
  bool isLoading = false;

  bool usernameExist = false;
  String? receivedOTP; // Store OTP from API response

  final FocusNode userFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateButtonState);
    userNameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
    whatsappNumberController.addListener(_updateButtonState);
    phoneNumberController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    cityController.addListener(_updateButtonState);
    experienceInYearsController.addListener(_updateButtonState);
    addressController.addListener(_updateButtonState);

    userFocusNode.addListener(() {
      if (!userFocusNode.hasFocus) {
        checkUsername();
      }
    });
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          nameController.text.isNotEmpty &&
          userNameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          experienceInYearsController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          usernameExist;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    countryCodeController.dispose();
    whatsappNumberController.dispose();
    emailController.dispose();
    cityController.dispose();
    experienceInYearsController.dispose();
    addressController.dispose();
    easyPaisaController.dispose();
    jazzCashController.dispose();
    bankDetailsController.dispose();
    remarksController.dispose();

    userFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    AuthenticationHeader(),
                    AuthenticationHeaderText(
                      title: 'Sign up',
                      subtitle:
                          'Create your account and enjoy a rewarding experience',
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              controller: nameController,
                              hintText: "Name",
                              prefixImage: "iconusername.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: userNameController,
                              hintText: "Mobile No. as Username",
                              prefixImage: "iconusername.png",
                              keyboardType: TextInputType.phone,
                              focusNode: userFocusNode,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: passwordController,
                              hintText: "Password (Sign In Password)",
                              prefixImage: "iconpassword.png",
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: confirmPasswordController,
                              hintText: "Confirm password",
                              prefixImage: "iconpassword.png",
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                SizedBox(
                                  width: 130, // 👈 first field ka fixed width
                                  child: AppTextField(
                                    controller: countryCodeController,
                                    hintText: "",
                                    prefixImage: "iconpakistan.png",
                                    suffixImage: "icondropdown.png",
                                    prevalue: '+92',
                                  ),
                                ),
                                const SizedBox(width: 5), // spacing
                                Expanded(
                                  child: AppTextField(
                                    controller: phoneNumberController,
                                    hintText: "Whatsapp Number",
                                    prefixImage: "iconphonenumber.png",
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: emailController,
                              hintText: "Email",
                              prefixImage: "iconmessage.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: cityController,
                              hintText: "City",
                              prefixImage: "iconlocation.png",
                              suffixImage: "icondropdown.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: experienceInYearsController,
                              hintText: "Experience In Years",
                              prefixImage: "iconpassword.png",
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: addressController,
                              hintText: "Address",
                              prefixImage: "iconaddress.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: easyPaisaController,
                              hintText: "Easypaisa Details",
                              prefixImage: "iconcard.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: jazzCashController,
                              hintText: "Jazz Cash Details",
                              prefixImage: "iconcard.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: bankDetailsController,
                              hintText: "Bank Account Details",
                              prefixImage: "iconcard.png",
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: remarksController,
                              hintText: "Remarks",
                              prefixImage: "iconchat.png",
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Sign Up',
                              onPressed: () {
                                getOTP();
                              },
                              enabled: isButtonEnabled,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Do you already have an account? ",
                                  style: GoogleFonts.inter(fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login Now",
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
                  ],
                ),
              ),
            ),
            if (isLoading) Loader(),
          ],
        ),
      ),
    );
  }

  void checkUsername() async {
    if (userNameController.text.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final String phoneNumber = userNameController.text;

      final response = await api.request(
        path: CheckUserName,
        type: RequestType.post,
        data: {'username': phoneNumber},
        useFormData: true,
      );

      final json = response.data;
      final model = CheckUsernameModel.fromJson(json);

      if (model.error == 0) {
        usernameExist = true;
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Registration Failed"),
            content: Text(model.message),
            actions: [
              TextButton(
                onPressed: () {
                  usernameExist = false;
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
          title: const Text("Registration Failed"),
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

  Future<void> userregistration() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();

      final response = await api.request(
        path: UserRegistration,
        type: RequestType.post,
        data: {
          'name': nameController.text,
          'username': userNameController.text,
          'password': passwordController.text,
          'city': cityController.text,
          'experience': experienceInYearsController.text,
          'address': addressController.text,
          'email': emailController.text,
          'whatsapp': whatsappNumberController.text,
          'easy_paise': easyPaisaController.text,
          'jazz_cash': jazzCashController.text,
          'bank_account': bankDetailsController.text,
          'remarks': remarksController.text,
        },
        useFormData: true,
      );

      final json = response.data;
      final user = UserRegistrationModel.fromJson(json);

      if (user.error == 0) {
        // Successful registration
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistrationSuccessful(),
          ),
        );
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Registration Failed"),
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
          title: const Text("Registration Failed"),
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

  Future<void> getOTP() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();

      final response = await api.request(
        path: SendOTP,
        type: RequestType.post,
        data: {'username': userNameController.text},
        useFormData: true,
      );

      final json = response.data;
      final model = SendOTPModel.fromJson(json);

      if (model.error == 0) {
        // Store the OTP from response
        receivedOTP = model.send_otp.toString();
        // Show OTP dialog popup
        showOTPDialog();
      } else {
        // Show error alert from response message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("OTP Failed"),
            content: Text(model.message),
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
          title: const Text("Sent OTP Failed"),
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

  void showOTPDialog() {
    String enteredOTP = '';
    bool isOTPComplete = false;
    bool isVerifying = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogBuilderContext) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 360;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter OTP',
                        style: GoogleFonts.inter(
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter the 5-digit OTP code sent to ${userNameController.text}',
                        style: GoogleFonts.inter(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // OTP Fields Container - responsive and centered
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 16,
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: OTPInputWidget(
                              length: 5,
                              onCompleted: (code) {
                                enteredOTP = code;
                                setDialogState(() {
                                  isOTPComplete = true;
                                });
                              },
                              onChanged: (code) {
                                enteredOTP = code;
                                setDialogState(() {
                                  isOTPComplete = code.length == 5;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (isVerifying)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: CircularProgressIndicator(),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: isSmallScreen ? 100 : 120,
                            child: ElevatedButton(
                              onPressed: (isOTPComplete && !isVerifying)
                                  ? () async {
                                      // Validate OTP
                                      if (receivedOTP == null ||
                                          receivedOTP!.isEmpty) {
                                        showDialog(
                                          context: dialogBuilderContext,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Error"),
                                            content: const Text(
                                              "OTP not received. Please try again.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  dialogBuilderContext,
                                                ),
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          ),
                                        );
                                        return;
                                      }

                                      setDialogState(() {
                                        isVerifying = true;
                                      });

                                      // Pad OTP to 5 digits if needed (e.g., 123 -> 00123)
                                      String expectedOTP = receivedOTP!.padLeft(
                                        5,
                                        '0',
                                      );
                                      // Take only first 5 digits if OTP is longer
                                      if (expectedOTP.length > 5) {
                                        expectedOTP = expectedOTP.substring(
                                          0,
                                          5,
                                        );
                                      }

                                      // Validate entered OTP with received OTP
                                      if (enteredOTP == expectedOTP) {
                                        // OTP matched - close dialog and call registration
                                        Navigator.pop(dialogBuilderContext);
                                        await userregistration();
                                      } else {
                                        // OTP mismatch
                                        setDialogState(() {
                                          isVerifying = false;
                                        });
                                        showDialog(
                                          context: dialogBuilderContext,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Invalid OTP"),
                                            content: const Text(
                                              "The OTP you entered is incorrect. Please try again.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                disabledBackgroundColor:
                                    kDefaultDisabledButtonColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 10 : 12,
                                  horizontal: isSmallScreen ? 16 : 20,
                                ),
                              ),
                              child: Text(
                                'Verify',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 14 : 16,
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
            );
          },
        );
      },
    );
  }
}
