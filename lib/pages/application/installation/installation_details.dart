import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/application/installation/installation_completed.dart';
import 'package:loyalty_program/models/all_items_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:loyalty_program/models/add_installation_model.dart';
import 'package:dio/dio.dart';
import 'package:loyalty_program/components/loader.dart';

class InstallationDetails extends StatefulWidget {
  final String serialNumber;
  final String? barcodeFormat;
  final String? itemId;

  const InstallationDetails({
    super.key,
    required this.serialNumber,
    this.barcodeFormat,
    this.itemId,
  });

  @override
  State<InstallationDetails> createState() => _InstallationDetailsState();
}

class _InstallationDetailsState extends State<InstallationDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController installationController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  // Data from previous screen
  late String serialNumber;
  String? barcodeFormat;

  bool isButtonEnabled = false;
  bool isLoading = false;
  UserModel? user;
  List<Item> items = [];
  Item? selectedItem;
  List<File> selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  final int maxImages = 3;
  @override
  void initState() {
    super.initState();
    // _loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllItems();
    });
    // Initialize data from previous screen
    serialNumber = widget.serialNumber;
    barcodeFormat = widget.barcodeFormat;
  }

  void _loadUser() async {
    user = await UserPrefsService.getUser();
    setState(() {
      nameController.text = user?.name ?? '';
      phoneController.text = user?.contactNos ?? '';
    }); // if you want to update UI after loading
  }

  Future<void> _pickImageFromCamera() async {
    if (selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum $maxImages images allowed")),
      );
      return;
    }

    final hasPermission = await Permission.camera.request();
    if (hasPermission.isDenied) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          selectedImages.add(File(image.path));
        });
        print("Image captured: ${image.path}");
      }
    } catch (e) {
      print("Error picking image from camera: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to capture image: $e")));
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum $maxImages images allowed")),
      );
      return;
    }

    final hasPermission = await Permission.photos.request();
    if (hasPermission.isDenied) return;

    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 80,
      );

      if (images.isNotEmpty) {
        int remainingSlots = maxImages - selectedImages.length;
        List<XFile> imagesToAdd = images.take(remainingSlots).toList();

        setState(() {
          selectedImages.addAll(imagesToAdd.map((e) => File(e.path)));
        });

        if (images.length > remainingSlots) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Only $remainingSlots more image(s) allowed. Maximum is $maxImages.",
              ),
            ),
          );
        }

        print("Images selected: ${imagesToAdd.length}");
      }
    } catch (e) {
      print("Error picking images from gallery: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to select images: $e")));
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Select Image Source',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: kPrimaryColor),
                title: Text('Camera', style: GoogleFonts.inter(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: kPrimaryColor),
                title: Text('Gallery', style: GoogleFonts.inter(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
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
                      height: 44,
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
                            'Serial Number: ' + widget.serialNumber,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: nameController,
                      hintText: 'Client Name',
                      editable: true,
                      prefixImage: "iconusername.png",
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
                            hintText: "Client Mobile",
                            prefixImage: "iconphonenumber.png",
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: widget.itemId != null && widget.itemId!.isNotEmpty
                          ? null
                          : () {
                              _showProductsPopup(context);
                            },
                      child: AbsorbPointer(
                        absorbing:
                            widget.itemId != null && widget.itemId!.isNotEmpty,
                        child: AppTextField(
                          controller: productController,
                          hintText: 'Item Installed',
                          prefixImage: 'iconproduct.png',
                          suffixImage: 'icondropdown.png',
                          editable:
                              widget.itemId == null || widget.itemId!.isEmpty,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: cityController,
                      hintText: 'Installation City',
                      editable: true,
                      prefixImage: "iconlocation.png",
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      controller: addressController,
                      hintText: 'Installation Address',
                      prefixImage: 'iconaddress.png',
                    ),

                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: installationController,
                            hintText: 'Upload Pics of Installation Site',
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
                            onPressed: _showImageSourceDialog,
                          ),
                        ),
                      ],
                    ),
                    if (selectedImages.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        '${selectedImages.length}/$maxImages images selected',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (selectedImages.isNotEmpty) ...[
                      SizedBox(height: 15),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        selectedImages[index],
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImages.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    AppTextField(
                      controller: remarksController,
                      hintText: 'Remarks',
                      prefixImage: 'iconchat.png',
                    ),
                    SizedBox(height: 20),
                    PrimaryButton(
                      text: 'Save',
                      onPressed: uploadInstallationData,
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
        // If itemId is provided, find and set the product name, then disable the field
        if (widget.itemId != null && widget.itemId!.isNotEmpty) {
          final foundItem = items.firstWhere(
            (item) => item.id == widget.itemId,
            orElse: () => Item(id: '', name: ''),
          );
          if (foundItem.id.isNotEmpty) {
            setState(() {
              selectedItem = foundItem;
              productController.text = foundItem.name;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
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
        'installation_city': cityController.text,
        'installation_address': addressController.text,
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

      if (add_installation.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InstallationSuccessfull(message: add_installation.message),
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

  void _showProductsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Product',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Items List
                Flexible(
                  child: items.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'No products available',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isLastItem = index == items.length - 1;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedItem = item;
                                  productController.text = item.name;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: isLastItem
                                      ? null
                                      : Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (item.id.isNotEmpty) ...[
                                            SizedBox(height: 4),
                                            Text(
                                              'ID: ${item.id}',
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
