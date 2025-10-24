import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/pages/application/installation/installation_completed.dart';

class InstallationDetails extends StatefulWidget {
  final String serialNumber;
  final String? barcodeFormat;

  const InstallationDetails({
    super.key,
    required this.serialNumber,
    this.barcodeFormat,
  });

  @override
  State<InstallationDetails> createState() => _InstallationDetailsState();
}

class _InstallationDetailsState extends State<InstallationDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  // Data from previous screen
  late String serialNumber;
  String? barcodeFormat;

  @override
  void initState() {
    super.initState();
    // Initialize data from previous screen
    serialNumber = widget.serialNumber;
    barcodeFormat = widget.barcodeFormat;
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
                    CustomHeading(heading: 'Enter Installation Details'),
                    SizedBox(height: 20),
                    Container(
                      height: 74,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kPrimaryColor,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "72901063",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'SOLAR HYBRID INVERTER 1.6 (KVA)',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: nameController,
                      hintText: 'Full Name',
                      editable: true,
                      prefixImage: "iconusername.png",
                      prevalue: 'Afif Shaukat',
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: 130,
                          child: AppTextField(
                            controller: codeController,
                            hintText: '',
                            prefixImage: "iconpakistan.png",
                            suffixImage: "icondropdown.png",
                            prevalue: '+92',
                          ),
                        ),
                        const SizedBox(width: 5), // spacing
                        Expanded(
                          child: AppTextField(
                            controller: phoneController,
                            hintText: "Enter Phone number",
                            prefixImage: "iconphonenumber.png",
                            keyboardType: TextInputType.phone,
                            prevalue: '333 1234567',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: productController,
                      hintText: 'Product',
                      prefixImage: 'iconproduct.png',
                      suffixImage: 'icondropdown.png',
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: cityController,
                      hintText: 'City',
                      prefixImage: 'iconlocation.png',
                      suffixImage: 'icondropdown.png',
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: addressController,
                      hintText: 'Enter your Full Address',
                      prefixImage: 'iconaddress.png',
                    ),

                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: addressController,
                            hintText: 'Installation Proof',
                            prefixImage: 'iconinstallation.png',
                            editable: false,
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 55,
                          width: 100,
                          child: PrimaryButton(
                            text: 'Browse',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: remarksController,
                      hintText: 'Enter your Remarks',
                      prefixImage: 'iconchat.png',
                    ),
                    SizedBox(height: 20),
                    PrimaryButton(
                      text: 'Save',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InstallationSuccessfull(),
                          ),
                        );
                      },
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
