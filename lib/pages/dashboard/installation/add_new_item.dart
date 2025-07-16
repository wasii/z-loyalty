import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/pages/dashboard/installation/item_added_successfully.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addMobileController = TextEditingController();
  final TextEditingController addItemController = TextEditingController();
  final TextEditingController addCityController = TextEditingController();
  final TextEditingController addAddressController = TextEditingController();
  final TextEditingController addFilesController = TextEditingController();
  final TextEditingController addRemarksController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    addNameController.addListener(_updateButtonState);
    addMobileController.addListener(_updateButtonState);
    addItemController.addListener(_updateButtonState);
    addCityController.addListener(_updateButtonState);
    addAddressController.addListener(_updateButtonState);
    addFilesController.addListener(_updateButtonState);
    addRemarksController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          addNameController.text.isNotEmpty &&
          addMobileController.text.isNotEmpty &&
          addItemController.text.isNotEmpty &&
          addCityController.text.isNotEmpty &&
          addAddressController.text.isNotEmpty &&
          addFilesController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    addNameController.dispose();
    addMobileController.dispose();
    addItemController.dispose();
    addCityController.dispose();
    addAddressController.dispose();
    addFilesController.dispose();
    addRemarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: kPrimaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CommonScaffoldLayout(
        title: 'Installation',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "INSTALLATION, ADD NEW",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomInputField(
                      controller: addNameController,
                      headingText: "Name",
                      hintText: 'Enter your name',
                      isRequired: true,
                      textHeight: 57,
                    ),
                    CustomInputField(
                      controller: addMobileController,
                      headingText: "Mobile",
                      hintText: 'Enter your mobile number',
                      isRequired: true,
                      textHeight: 57,
                    ),
                    CustomInputField(
                      controller: addItemController,
                      headingText: "Items",
                      hintText: 'Please select items',
                      isRequired: true,
                      textHeight: 57,
                    ),
                    CustomInputField(
                      controller: addCityController,
                      headingText: "City",
                      hintText: 'Enter your city name',
                      isRequired: true,
                      textHeight: 57,
                    ),
                    CustomInputField(
                      controller: addAddressController,
                      headingText: "Address",
                      hintText: 'Enter your address',
                      isRequired: true,
                      textHeight: 90,
                    ),
                    CustomInputField(
                      controller: addFilesController,
                      headingText: "Upload pics of installation site",
                      hintText: '',
                      isRequired: true,
                      textHeight: 57,
                    ),
                    CustomInputField(
                      controller: addRemarksController,
                      headingText: "Remarks",
                      hintText: 'Enter your name',
                      isRequired: false,
                      textHeight: 90,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
        child: CustomPrimaryButton(
          text: 'Next',
          isDisabled: isButtonEnabled,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemAddedSuccessfully()),
            );
          },
          showImage: false,
        ),
      ),
    );
  }
}
