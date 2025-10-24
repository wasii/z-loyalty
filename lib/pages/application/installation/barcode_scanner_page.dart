import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController? cameraController;
  final TextEditingController manualInputController = TextEditingController();

  bool isScanned = false;
  bool isTorchOn = false;
  bool hasError = false;
  String? errorMessage;
  bool showSuccessOverlay = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Check if we're on a real device
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        cameraController = MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true, // Enable image capture
        );
        await cameraController!.start();
        if (mounted) {
          setState(() {
            hasError = false;
          });
        }
      } else {
        // Simulator or unsupported platform
        if (mounted) {
          setState(() {
            hasError = true;
            errorMessage = 'Camera not available on simulator';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = 'Camera error: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    manualInputController.dispose();
    super.dispose();
  }

  void _toggleTorch() {
    if (cameraController != null) {
      setState(() {
        isTorchOn = !isTorchOn;
      });
      cameraController!.toggleTorch();
    }
  }

  void _submitManualInput() {
    if (manualInputController.text.isNotEmpty) {
      Navigator.of(context).pop({
        'barcode': manualInputController.text,
        'image': null,
        'format': 'Manual Entry',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hasError ? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor: hasError ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: hasError ? Colors.black : Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          hasError ? 'Enter Barcode' : 'Scan Barcode',
          style: GoogleFonts.inter(
            color: hasError ? Colors.black : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: !hasError
            ? [
                IconButton(
                  icon: Icon(
                    isTorchOn ? Icons.flash_on : Icons.flash_off,
                    color: isTorchOn ? Colors.amber : Colors.white,
                  ),
                  onPressed: _toggleTorch,
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: () => cameraController?.switchCamera(),
                ),
              ]
            : null,
      ),
      body: hasError ? _buildManualInputScreen() : _buildScannerScreen(),
    );
  }

  Widget _buildScannerScreen() {
    if (cameraController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      children: [
        MobileScanner(
          controller: cameraController!,
          onDetect: (capture) {
            if (!isScanned) {
              isScanned = true;
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;

              if (barcodes.isNotEmpty) {
                final barcode = barcodes.first;

                // Show success feedback
                setState(() {
                  showSuccessOverlay = true;
                });

                // Wait a moment to show the success animation, then return
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    Navigator.of(context).pop({
                      'barcode': barcode.rawValue ?? '',
                      'image': image,
                      'format': barcode.format.name,
                    });
                  }
                });
              }
            }
          },
        ),
        // Scanning overlay
        CustomPaint(
          painter: ScannerOverlay(isSuccess: showSuccessOverlay),
          child: Container(),
        ),
        // Success overlay
        if (showSuccessOverlay)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      'Scan Successful!',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Processing...',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Instructions at bottom
        if (!showSuccessOverlay)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Place barcode within the frame to scan',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildManualInputScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'Camera Not Available',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            errorMessage ?? 'Unable to access camera on simulator',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: manualInputController,
              decoration: InputDecoration(
                hintText: 'Enter barcode manually',
                hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                prefixIcon: Icon(Icons.edit, color: Colors.grey[600]),
              ),
              style: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitManualInput,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Note: Camera scanning is available on real devices only',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for scanner overlay
class ScannerOverlay extends CustomPainter {
  final bool isSuccess;

  ScannerOverlay({this.isSuccess = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanAreaWidth = size.width * 0.7;
    final scanAreaHeight = size.height * 0.3;
    final left = (size.width - scanAreaWidth) / 2;
    final top = (size.height - scanAreaHeight) / 2;
    final scanRect = Rect.fromLTWH(left, top, scanAreaWidth, scanAreaHeight);

    // Draw darkened overlay around scan area
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw corner brackets with color based on success state
    final bracketPaint = Paint()
      ..color = isSuccess ? Colors.green : Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSuccess ? 6 : 4
      ..strokeCap = StrokeCap.round;

    const bracketLength = 30.0;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + bracketLength),
      Offset(left, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + bracketLength, top),
      bracketPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + scanAreaWidth - bracketLength, top),
      Offset(left + scanAreaWidth, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaWidth, top),
      Offset(left + scanAreaWidth, top + bracketLength),
      bracketPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + scanAreaHeight - bracketLength),
      Offset(left, top + scanAreaHeight),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaHeight),
      Offset(left + bracketLength, top + scanAreaHeight),
      bracketPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + scanAreaWidth - bracketLength, top + scanAreaHeight),
      Offset(left + scanAreaWidth, top + scanAreaHeight),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaWidth, top + scanAreaHeight - bracketLength),
      Offset(left + scanAreaWidth, top + scanAreaHeight),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
