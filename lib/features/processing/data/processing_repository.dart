import 'package:google_ml_kit/google_ml_kit.dart';

import '/features/processing/domain/entities/ocr_line.dart';

abstract class ProcessingRepository {
  Future<List<OcrLine>> extractLinesFromImages(String imagePath);
  void dispose();
}

class ProcessingRepositoryImpl implements ProcessingRepository {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  @override
  void dispose() {
    _recognizer.close();
  }

  @override
  Future<List<OcrLine>> extractLinesFromImages(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _recognizer.processImage(
        inputImage,
      );

      final lines = <OcrLine>[];

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          lines.add(
            OcrLine(text: line.text, top: line.boundingBox.top.toDouble()),
          );
        }
      }

      return lines;
    } catch (e) {
      throw Exception('Failed to run OCR on this image: $e');
    }
  }
}
