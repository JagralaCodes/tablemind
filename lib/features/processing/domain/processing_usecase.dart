import 'package:app/features/processing/data/processing_repository.dart';

import '../../../shared/entities/menu_entity.dart';
import 'menu_parser.dart';

class ScanProgress {
  final int completed;
  final int total;
  final Menu menu;

  const ScanProgress({
    required this.completed,
    required this.total,
    required this.menu,
  });

  bool get isDone => completed == total;
}

class ProcessingUseCase {
  final ProcessingRepository repository;
  final MenuParser parser;

  ProcessingUseCase(this.repository, this.parser);

  Stream<ScanProgress> scanMenuFromImages(List<String> imagePaths) async* {
    final allItems = <MenuItem>[];
    // Kept ONLY for the diagnostic message below if parsing fails — not
    // used for anything else. Lets you see exactly what OCR read without
    // needing to add your own debugPrint next time this happens.
    final allRawLines = <String>[];
    String carryOverCategory = 'Menu';
    var anyTextFound = false;

    for (var i = 0; i < imagePaths.length; i++) {
      final lines = await repository.extractLinesFromImages(imagePaths[i]);

      if (lines.isNotEmpty) {
        anyTextFound = true;
        allRawLines.addAll(lines.map((l) => l.text));

        final pageMenu = parser.parse(
          lines,
          startingCategory: carryOverCategory,
        );
        allItems.addAll(pageMenu.items);
        if (pageMenu.items.isNotEmpty) {
          carryOverCategory = pageMenu.items.last.category;
        }
      }

      yield ScanProgress(
        completed: i + 1,
        total: imagePaths.length,
        menu: Menu(items: List.of(allItems)),
      );
    }

    if (allItems.isEmpty) {
      if (!anyTextFound) {
        // The OCR engine itself found nothing at all — a camera/image
        // quality problem (blurry, too dark, no text in frame).
        throw Exception(
          'No text could be detected in these images. Try clearer, '
          'well-lit photos.',
        );
      } else {
        // OCR DID read text, but none of it matched the parser's rules
        // for "this looks like a priced menu item." This points at the
        // MenuParser's heuristics needing a tweak for this menu's
        // layout, not at the camera or ML Kit. The raw sample below is
        // exactly what to paste back for tuning the regex/rules.
        final sample = allRawLines.take(15).join(' | ');
        throw Exception(
          'Text was detected but no menu items could be parsed from it. '
          'Raw OCR sample: $sample',
        );
      }
    }
  }
}
