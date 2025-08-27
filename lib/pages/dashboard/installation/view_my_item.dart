import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/models/all_items_model.dart';
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

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditable) {
        getAllItems();
      }
    });
    serialNumberController.text = widget.myProduct.serialNumber;

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

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
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
