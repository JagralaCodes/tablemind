class MenuItem {
  final String id;
  final String name;
  final double? price;
  final String currencySymbol;
  final String category;
  final String? description;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.currencySymbol,
    required this.category,
    this.description,
  });

  MenuItem copyWith({
    String? description,
    double? price,
    String? currencySymbol,
  }) {
    return MenuItem(
      id: id,
      name: name,
      price: price ?? this.price,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      category: category,
      description: description ?? this.description,
    );
  }

  @override
  String toString() =>
      'MenuItem($category: $name — $currencySymbol${price ?? "?"})';
}

class Menu {
  final List<MenuItem> items;

  const Menu({required this.items});

  List<String> get categories => items.map((e) => e.category).toSet().toList();

  List<MenuItem> itemsInCategory(String category) =>
      items.where((e) => e.category == category).toList();
}
