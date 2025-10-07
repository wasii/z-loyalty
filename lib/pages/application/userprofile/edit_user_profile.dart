import 'package:flutter/material.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/primary_button.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dummyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bankDetailsController = TextEditingController();

  bool isButtonEnabled = false;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateButtonState);
    userNameController.addListener(_updateButtonState);
    phoneNumberController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    cityController.addListener(_updateButtonState);
    addressController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          nameController.text.isNotEmpty &&
          userNameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          cityController.text.isNotEmpty &&
          addressController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    phoneNumberController.dispose();
    dummyController.dispose();
    emailController.dispose();
    cityController.dispose();
    addressController.dispose();
    bankDetailsController.dispose();
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
        appBar: CustomNavigationBarWithBackButton(
          onBackTap: () {
            Navigator.pop(context);
          },
          showImage: false,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeading(heading: 'Edit Account Details'),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: nameController,
                          hintText: "Enter your Full name",
                          prefixImage: "iconusername.png",
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: userNameController,
                          hintText: "Enter your Username",
                          prefixImage: "iconusername.png",
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: 130, // 👈 first field ka fixed width
                              child: AppTextField(
                                controller: dummyController,
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
                                hintText: "Enter Phone number",
                                prefixImage: "iconphonenumber.png",
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: emailController,
                          hintText: "Enter your Email Address",
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
                          controller: bankDetailsController,
                          hintText: "Bank Account Details",
                          prefixImage: "iconcard.png",
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          text: 'Update',
                          onPressed: () {},
                          enabled: true,
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
    );
  }
}
