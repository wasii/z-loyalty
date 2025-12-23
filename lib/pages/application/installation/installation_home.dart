import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/components/secondary_button.dart';
import 'package:loyalty_program/pages/application/installation/installation_details.dart';
import 'package:loyalty_program/pages/application/installation/barcode_scanner_page.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/models/verify_serial_number_model.dart';

class InstallationHome extends StatefulWidget {
  const InstallationHome({super.key});

  @override
  State<InstallationHome> createState() => _InstallationHomeState();
}

// D65D9J7A
class _InstallationHomeState extends State<InstallationHome> {
  final TextEditingController inputController = TextEditingController();
  bool isLoading = false;
  bool isVerified = false;
  bool isVerifyButtonEnabled = false;
  String? scannedBarcode;
  Uint8List? scannedImage;
  String? barcodeFormat;
  String? itemId;

  @override
  void initState() {
    super.initState();
    inputController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      isVerifyButtonEnabled = inputController.text.isNotEmpty;
      // Reset verification status when text changes
      if (inputController.text.isEmpty) {
        isVerified = false;
      }
    });
  }

  Future<void> _scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        scannedBarcode = result['barcode'] as String?;
        scannedImage = result['image'] as Uint8List?;
        barcodeFormat = result['format'] as String?;

        // Auto-fill the text field with scanned barcode
        if (scannedBarcode != null) {
          inputController.text = scannedBarcode!;
        }
      });
    }
  }

  @override
  void dispose() {
    inputController.removeListener(_onTextChanged);
    inputController.dispose();
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeading(heading: 'Scan Loyalty Card'),
                    SizedBox(height: 20),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kBoxBackgroundColor,
                      ),
                      child: scannedBarcode != null
                          ? scannedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      children: [
                                        Image.memory(
                                          scannedImage!,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                        color: Colors.grey[400],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        'Image Error',
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                        ),
                                        // Remove button in top right corner
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withAlpha(60),
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  scannedImage = null;
                                                  scannedBarcode = null;
                                                  barcodeFormat = null;
                                                  inputController.clear();
                                                });
                                              },
                                              padding: EdgeInsets.all(4),
                                              constraints: BoxConstraints(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.qr_code_2,
                                          size: 60,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Barcode Entered",
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          scannedBarcode!,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        if (barcodeFormat != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: Text(
                                              barcodeFormat!,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "${kIconFolder}iconimagepreview.png",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Image Preview",
                                  style: GoogleFonts.inter(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: 'Scan Now',
                            onPressed: _scanBarcode,
                          ),
                        ),
                        // SizedBox(width: 10),
                        // Expanded(
                        //   child: PrimaryButton(
                        //     text: 'Browse',
                        //     onPressed: () {},
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 229,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kBoxBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Enter Loyalty Card",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 25),
                            AppTextField(
                              controller: inputController,
                              hintText: 'Loyalty Code',
                              prefixImage: "iconcard.png",
                            ),
                            SizedBox(height: 25),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Verify Now',
                                    onPressed: verifySerialNumber,
                                    enabled: isVerifyButtonEnabled,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Next',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => InstallationDetails(
                                            serialNumber: inputController.text,
                                            barcodeFormat: barcodeFormat,
                                            itemId: itemId,
                                          ),
                                        ),
                                      );
                                    },
                                    enabled: isVerified,
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
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void verifySerialNumber() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final response = await api.request(
        path: VerifySerialNumber,
        type: RequestType.post,
        data: {'serial_number': inputController.text},
        useFormData: true,
      );

      final json = response.data;
      final verify_serial = VerifySerialNumberModel.fromJson(json);
      if (verify_serial.error == 0) {
        if (verify_serial.isSystemSerial == 1) {
          itemId = verify_serial.itemId;
        }
        setState(() {
          isVerified = true;
        });
        itemId = verify_serial.itemId;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Serial number verified successfully!'),
            backgroundColor: kPrimaryColor,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          isVerified = false;
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Verify Serial Failed"),
            content: Text(verify_serial.message),
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
      // if (verify_serial.isSystemSerial == 0) {
      //    else {
      //   setState(() {
      //     isVerified = true;
      //   });
      //   itemId = verify_serial.itemId;
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Serial number verified successfully!'),
      //       backgroundColor: kPrimaryColor,
      //       duration: Duration(seconds: 2),
      //     ),
      //   );
      // }
      // }
    } catch (e) {
      setState(() {
        isVerified = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Verify Serial Failed"),
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
