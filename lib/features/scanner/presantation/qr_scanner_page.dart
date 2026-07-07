import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/widgets/link_menu_bottom_sheet.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isFlashOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [_buildTopSection(), _buildBottomSection(context)],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Scan QR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Back and then open
                  context.pop();

                  // Open Link
                  showDialog(
                    context: context,
                    builder: (context) => const LinkMenuBottomSheet(),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('Enter Link', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Align QR code within the frame',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(width: 48, height: 1, color: Colors.grey),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Dark grey background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan the digital QR code on your table.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Not a photo or dish.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              // Header
              // Scanner Area
              Expanded(
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          debugPrint('Barcode found! ${barcode.rawValue}');
                        }
                      },
                    ),
                    // Scanner Overlay (dimmed background with clear center)
                    CustomPaint(
                      size: Size.infinite,
                      painter: ScannerOverlayPainter(),
                    ),
                    // Bottom Buttons
                    Positioned(
                      bottom: 104,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIconButton(
                                icon: Icons.image_outlined,
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (image != null) {
                                    final BarcodeCapture? capture =
                                        await _controller.analyzeImage(
                                          image.path,
                                        );
                                    if (capture == null && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No QR code found in image.',
                                          ),
                                        ),
                                      );
                                    } else if (capture != null) {
                                      // Handle found barcode from image here
                                      for (final barcode in capture.barcodes) {
                                        debugPrint(
                                          'Barcode found from image! ${barcode.rawValue}',
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildIconButton(
                                icon: Icons.help_outline,
                                onPressed: () {
                                  // Help action
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildIconButton(
                                icon: _isFlashOn
                                    ? Icons.light_mode
                                    : Icons.light_mode_outlined,
                                onPressed: () {
                                  _controller.toggleTorch();
                                  setState(() {
                                    _isFlashOn = !_isFlashOn;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Define the scanning area
    final scanAreaWidth = size.width * 0.85;
    final scanAreaHeight = scanAreaWidth; // Square
    final rect = Rect.fromCenter(
      center: Offset(
        size.width / 2,
        size.height * 0.4,
      ), // Slightly above center
      width: scanAreaWidth,
      height: scanAreaHeight,
    );

    // Draw the dimmed background with a clear hole
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw the white border for the scanning area
    final borderPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
