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
import 'package:loyalty_program/models/all_items_model.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/dashboard/installation/item_added_successfully.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AddNewItem extends StatefulWidget {
  final String serialNumber;
  const AddNewItem({super.key, required this.serialNumber});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  Future<bool> requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    var photosStatus = await Permission.photos.request();

    if (cameraStatus.isGranted && photosStatus.isGranted) {
      print("All permissions granted ✅");
      return true;
    } else {
      print("Permissions denied ❌");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
            "Please enable Camera and Photo access from Settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
      return false;
    }
  }

  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addMobileController = TextEditingController();
  final TextEditingController addItemController = TextEditingController();
  final TextEditingController addCityController = TextEditingController();
  final TextEditingController addAddressController = TextEditingController();

  final TextEditingController addRemarksController = TextEditingController();

  List<File> selectedImages = [];

  bool isButtonEnabled = false;
  bool isLoading = false;
  UserModel? user;
  List<Item> items = [];
  Item? selectedItem;

  @override
  void initState() {
    super.initState();
    _loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllItems();
    });
    serialNumberController.text = widget.serialNumber;
    addNameController.addListener(_updateButtonState);
    addMobileController.addListener(_updateButtonState);
    addItemController.addListener(_updateButtonState);
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
    // bool granted = await requestPermissions();
    // if (!granted) {
    //   return;
    // }
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
          addItemController.text.isNotEmpty &&
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
    addItemController.dispose();
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
                          isRequired: false,
                          textHeight: 57,
                          editable: false,
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
                          editable: false,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Item? tempSelectedItem = selectedItem;
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                    return AlertDialog(
                                      title: Text('Select Item'),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        height: 300,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            final item = items[index];
                                            return RadioListTile<Item>(
                                              title: Text(
                                                item.name,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                              value: item,
                                              groupValue: tempSelectedItem,
                                              onChanged: (Item? value) {
                                                setStateDialog(() {
                                                  tempSelectedItem = value!;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 10.0,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryColor,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (tempSelectedItem != null) {
                                                  setState(() {
                                                    selectedItem =
                                                        tempSelectedItem!;
                                                    addItemController.text =
                                                        selectedItem?.name ??
                                                        '';
                                                  });
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Okay',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: AbsorbPointer(
                            child: CustomInputField(
                              controller: addItemController,
                              headingText: "Items",
                              hintText: 'Please select items',
                              isRequired: true,
                              textHeight: 57,
                            ),
                          ),
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
        'user_id': user?.id ?? 0,
        'serial_number': widget.serialNumber,
        'client_name': user?.username,
        'client_mobile': user?.contactNos,
        'item_id': selectedItem?.id ?? '1',
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
            title: const Text("Add New Item Failed"),
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
          title: const Text("Add New Item Failed"),
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

  void getAllItems() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final response = await api.request(
        path: GetProductList,
        type: RequestType.post,
        data: {},
        useFormData: true,
      );

      final json = response.data;
      final allItem = AllItemsResponse.fromJson(json);
      if (allItem.error == 0) {
        items = allItem.items;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }
}
