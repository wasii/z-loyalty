// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/models/add_installation_model.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/dashboard/installation/item_added_successfully.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewItem extends StatefulWidget {
  final String serialNumber;
  const AddNewItem({super.key, required this.serialNumber});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addMobileController = TextEditingController();
  // final TextEditingController addItemController = TextEditingController();
  final TextEditingController addCityController = TextEditingController();
  final TextEditingController addAddressController = TextEditingController();

  final TextEditingController addRemarksController = TextEditingController();

  List<File> selectedImages = [];

  bool isButtonEnabled = false;
  bool isLoading = false;
  UserModel? user;
  @override
  void initState() {
    super.initState();
    _loadUser();
    serialNumberController.text = widget.serialNumber;
    addNameController.addListener(_updateButtonState);
    addMobileController.addListener(_updateButtonState);
    // addItemController.addListener(_updateButtonState);
    addCityController.addListener(_updateButtonState);
    addAddressController.addListener(_updateButtonState);

    addRemarksController.addListener(_updateButtonState);
  }

  void _loadUser() async {
    user = await UserPrefsService.getUser();
    setState(() {
      addNameController.text = user?.name ?? '';
      addMobileController.text = user?.contactNos ?? '';
    }); // if you want to update UI after loading
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          addNameController.text.isNotEmpty &&
          addMobileController.text.isNotEmpty &&
          // addItemController.text.isNotEmpty &&
          addCityController.text.isNotEmpty &&
          addAddressController.text.isNotEmpty &&
          selectedImages.isNotEmpty;
    });
  }

  @override
  void dispose() {
    serialNumberController.dispose();
    addNameController.dispose();
    addMobileController.dispose();
    // addItemController.dispose();
    addCityController.dispose();
    addAddressController.dispose();
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
      body: Stack(
        children: [
          CommonScaffoldLayout(
            title: 'Installation',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "INSTALLATION, ADD NEW",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
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
                          controller: serialNumberController,
                          headingText: "Serial Number",
                          hintText: 'Enter Serial Number',
                          isRequired: true,
                          textHeight: 57,
                        ),
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
                        // CustomInputField(
                        //   controller: addItemController,
                        //   headingText: "Items",
                        //   hintText: 'Please select items',
                        //   isRequired: true,
                        //   textHeight: 57,
                        // ),
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
                          textHeight: 57,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Upload pics of installation site',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: kDefaultTextFieldColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: kTextFieldMandatoryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 90,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedImages.length + 1,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                            ),
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 20.0,
                                                    ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.photo_library,
                                                      ),
                                                      title: Text(
                                                        'Select Picture',
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        _pickImage(
                                                          ImageSource.gallery,
                                                        );
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.camera_alt,
                                                      ),
                                                      title: Text(
                                                        'Capture Picture',
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        _pickImage(
                                                          ImageSource.camera,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 0,
                                          right: 0,
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                selectedImages[index - 1],
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: -8,
                                              right: -8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedImages.removeAt(
                                                      index - 1,
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: addRemarksController,
                          headingText: "Remarks",
                          hintText: 'Enter your remarks',
                          isRequired: false,
                          textHeight: 57,
                        ),
                        SizedBox(height: 20),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: CustomPrimaryButton(
                            text: 'Search',
                            isDisabled: isButtonEnabled,
                            onPressed: () {
                              uploadInstallationData();
                            },
                            showImage: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) Loader(),
        ],
      ),
    );
  }

  void uploadInstallationData() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();

      final List<MultipartFile> imageFiles = await Future.wait(
        selectedImages.map((file) async {
          final fileName = '${file.path.split('/').last}.jpg'; // 👈 Ensure .jpg
          return await MultipartFile.fromFile(file.path, filename: fileName);
        }),
      );

      final formMap = {
        'user_id': 68,
        'serial_number': widget.serialNumber,
        'client_name': user?.username,
        'client_mobile': user?.contactNos,
        'item_id': '1',
        'installation_city': addCityController.text,
        'installation_address': addAddressController.text,
        'upload_pics[]': imageFiles,
      };

      final response = await api.request(
        path: AddInstallation,
        type: RequestType.post,
        data: formMap,
        useFormData: true,
      );

      final json = response.data;
      final add_installation = AddInstallationModel.fromJson(json);
      print("✅ Upload Response: $add_installation");

      if (add_installation.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ItemAddedSuccessfully(message: add_installation.message),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Verify Serial Failed"),
            content: Text(add_installation.message),
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

      // handle success UI, like navigation or snackbar
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Upload Failed"),
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
