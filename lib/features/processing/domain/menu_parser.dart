import 'package:app/features/processing/domain/entities/ocr_line.dart';
import 'package:app/shared/entities/menu_entity.dart';
import 'package:flutter/material.dart';

class MenuParser {
  static final RegExp _priceWithSymbol = RegExp(
    r'(?:[₹$€£]|Rs\.?|INR)\s?(\d+(?:[.,]\d{1,2})?)\s*$',
    caseSensitive: false,
  );

  // Fallback for menus with NO currency symbol at all, e.g. "Paneer Tikka
  // .......... 250" or a standalone line that just says "250".
  static final RegExp _bareTrailingPrice = RegExp(r'(\d+(?:\.\d{1,2})?)\s*$');

  Menu parse(List<OcrLine> lines, {String startingCategory = 'Menu'}) {
    final items = <MenuItem>[];
    String currentCategory = startingCategory;

    // A name we've seen but haven't found a price for YET — its price
    // might be sitting on the very next OCR line instead of the same one.
    MenuItem? pendingItem;

    void flushPending() {
      if (pendingItem != null) {
        items.add(pendingItem!);
        pendingItem = null;
      }
    }

    for (final line in lines) {
      final text = line.text.trim();
      if (text.isEmpty) continue;

      final price = _extractPrice(text);

      // ── Category header ────────────────────────────────────────────
      if (price == null && _looksLikeCategoryHeader(text)) {
        flushPending();
        currentCategory = _titleCase(text);
        continue;
      }

      // ── Line contains a price ──────────────────────────────────────
      if (price != null) {
        final rawName = text.substring(0, price.matchStart).trim();
        final name = rawName.replaceAll(RegExp(r'[.\-_\s]{2,}$'), '').trim();

        if (name.isEmpty) {
          // This line is JUST a price, e.g. "₹250" or "250" alone —
          // attach it to whichever item is still waiting for one.
          if (pendingItem != null) {
            items.add(
              pendingItem!.copyWith(
                price: price.value,
                currencySymbol: price.symbol,
              ),
            );
            pendingItem = null;
          } else if (items.isNotEmpty && items.last.price == null) {
            items[items.length - 1] = items.last.copyWith(
              price: price.value,
              currencySymbol: price.symbol,
            );
          }
          // else: an orphan price with no name to attach to — drop it.
          continue;
        }

        // Normal case: name and price together on one line.
        flushPending();
        items.add(
          MenuItem(
            id: '${items.length}',
            name: name,
            price: price.value,
            currencySymbol: price.symbol,
            category: currentCategory,
          ),
        );
        continue;
      }

      // ── No price on this line, not a category header ──────────────
      if (pendingItem == null) {
        // Treat as a candidate item name; its price may show up on the
        // next line.
        pendingItem = MenuItem(
          id: '${items.length}',
          name: text,
          price: null,
          currencySymbol: '',
          category: currentCategory,
        );
      } else if (items.isNotEmpty) {
        // We're already holding a pending name, so this text is more
        // likely a description of the last FINALIZED item.
        final last = items.last;
        items[items.length - 1] = last.copyWith(
          description: [
            last.description,
            text,
          ].where((s) => s != null && s.isNotEmpty).join(' '),
        );
      }
    }

    flushPending();
    return Menu(items: items);
  }

  _PriceMatch? _extractPrice(String text) {
    var match = _priceWithSymbol.firstMatch(text);
    var symbol = '';

    if (match != null) {
      symbol = match.group(0)!.trim().replaceAll(RegExp(r'[\d.,\s]'), '');
    } else {
      match = _bareTrailingPrice.firstMatch(text);
      if (match != null) {
        // Guard against false positives (phone numbers, order codes,
        // years) by capping how many digits a "bare" price can have,
        // instead of the old letters-in-the-line requirement — that
        // requirement was the actual bug: it silently rejected
        // standalone price-only lines, which is exactly what a
        // no-symbol, two-column menu produces.
        final digitsOnly = match.group(1)!.replaceAll('.', '');
        if (digitsOnly.length > 4) match = null;
      }
    }

    if (match == null) return null;
    final value = double.tryParse(match.group(1)!.replaceAll(',', '.'));
    if (value == null) return null;

    return _PriceMatch(matchStart: match.start, value: value, symbol: symbol);
  }

  bool _looksLikeCategoryHeader(String text) {
    if (text.length > 30) return false;
    final letters = text.replaceAll(RegExp(r'[^A-Za-z]'), '');
    if (letters.length < 3) return false;
    final upper = letters.replaceAll(RegExp(r'[^A-Z]'), '');
    return upper.length / letters.length > 0.8;
  }

  String _titleCase(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

class _PriceMatch {
  final int matchStart;
  final double value;
  final String symbol;

  const _PriceMatch({
    required this.matchStart,
    required this.value,
    required this.symbol,
  });
}
