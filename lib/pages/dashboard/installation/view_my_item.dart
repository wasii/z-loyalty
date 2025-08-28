import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/image_helper.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/models/all_items_model.dart';
import 'package:loyalty_program/models/delete_single_image_file_model.dart';
import 'package:loyalty_program/models/my_installation_list_model.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/network/api_service.dart';

class ViewMyItem extends StatefulWidget {
  final bool isEditable;
  final MyProductsInstallation myProduct;
  const ViewMyItem({
    super.key,
    required this.isEditable,
    required this.myProduct,
  });

  @override
  State<ViewMyItem> createState() => _ViewMyItemState();
}

class _ViewMyItemState extends State<ViewMyItem> {
  final TextEditingController IDController = TextEditingController();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadApiImages();
      if (widget.isEditable) {
        getAllItems();
        loadApiImages();
      }
    });

    IDController.text = widget.myProduct.installationId;
    serialNumberController.text = widget.myProduct.serialNumber;
    addNameController.text = widget.myProduct.clientName;
    addMobileController.text = widget.myProduct.clientMobile;
    addItemController.text = widget.myProduct.itemInstalled;
    addCityController.text = widget.myProduct.installationCity;
    addAddressController.text = widget.myProduct.installationAddress;
    if (widget.isEditable) {
      addNameController.addListener(_updateButtonState);
      addMobileController.addListener(_updateButtonState);
      addItemController.addListener(_updateButtonState);
      addCityController.addListener(_updateButtonState);
      addAddressController.addListener(_updateButtonState);

      addRemarksController.addListener(_updateButtonState);
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

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
        _updateButtonState(); // Call this to update button state after adding an image
      });
    }
  }

  Future<void> loadApiImages() async {
    // API se jo links aati hain unko string list me nikal lo
    // final urls = uploadPics
    //     .map<String>((pic) => pic['link_thumbnail'] as String)
    //     .toList();
    List<String> urls = [];
    for (var linkThumbnail in widget.myProduct.uploadPics) {
      urls.add(linkThumbnail.link);
    }
    // helper method call karo
    selectedImages = await ImageHelper.downloadImages(urls);

    setState(() {}); // UI update
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
              children: [
                Text(
                  'INSTALLATION, VIEW',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
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
                          controller: IDController,
                          headingText: "ID",
                          hintText: '',
                          isRequired: true,
                          textHeight: 57,
                          editable: false,
                        ),
                        CustomInputField(
                          controller: serialNumberController,
                          headingText: "Serial Number",
                          hintText: 'Enter Serial Number',
                          isRequired: true,
                          textHeight: 57,
                          editable: false,
                        ),
                        CustomInputField(
                          controller: addNameController,
                          headingText: "Name",
                          hintText: 'Enter your name',
                          isRequired: true,
                          textHeight: 57,
                          editable: widget.isEditable ? true : false,
                        ),
                        CustomInputField(
                          controller: addMobileController,
                          headingText: "Mobile",
                          hintText: 'Enter your mobile number',
                          isRequired: true,
                          textHeight: 57,
                          editable: widget.isEditable ? true : false,
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
                              editable: widget.isEditable ? true : false,
                            ),
                          ),
                        ),
                        CustomInputField(
                          controller: addCityController,
                          headingText: "City",
                          hintText: 'Enter your city name',
                          isRequired: true,
                          textHeight: 57,
                          editable: widget.isEditable ? true : false,
                        ),
                        CustomInputField(
                          controller: addAddressController,
                          headingText: "Address",
                          hintText: 'Enter your address',
                          isRequired: true,
                          textHeight: 57,
                          editable: widget.isEditable ? true : false,
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
                                  itemCount: (widget.isEditable
                                      ? (selectedImages.length >= 3
                                            ? 3
                                            : selectedImages.length + 1)
                                      : selectedImages.length),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    if (widget.isEditable &&
                                        selectedImages.length < 3 &&
                                        index == selectedImages.length) {
                                      return GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
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
                                                      leading: const Icon(
                                                        Icons.photo_library,
                                                      ),
                                                      title: const Text(
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
                                                      leading: const Icon(
                                                        Icons.camera_alt,
                                                      ),
                                                      title: const Text(
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
                                          child: const Icon(
                                            Icons.camera_alt,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    } else {
                                      final imageIndex = index;
                                      final file = selectedImages[imageIndex];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 0,
                                          right: 0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            showImageFilePopup(context, file);
                                          },
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  file,
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              if (widget.isEditable)
                                                Positioned(
                                                  top: -8,
                                                  right: -8,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      deleteSingleFile(
                                                        imageIndex,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black26,
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                  0,
                                                                  2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
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

  void showImageFilePopup(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: true, // user can dismiss by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 24,
          ), // horizontal margin
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close, color: kPrimaryColor),
                  label: Text("Close", style: TextStyle(color: kPrimaryColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(color: kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteSingleFile(int imageIndex) async {
    setState(() {
      isLoading = true;
    });
    var filePath = widget.myProduct.uploadPics[imageIndex].filePath;

    try {
      final api = ApiService();
      final response = await api.request(
        path: DeleteSingleFile,
        type: RequestType.post,
        data: {
          'installation_id': widget.myProduct.installationId,
          'file_path': filePath,
        },
        useFormData: true,
      );
      final json = response.data;
      final api_response = DeleteSingleImageFileModel.fromJson(json);
      if (api_response.error == 0) {
        setState(() {
          selectedImages.removeAt(imageIndex);
          _updateButtonState();
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
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
