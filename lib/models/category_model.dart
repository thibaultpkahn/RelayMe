class Category {
  final String name;

  Category({required this.name});

  // Convertir une catégorie en Map
  Map<String, String> toMap() {
    return {"name": name};
  }

  // Créer une catégorie depuis un Map
  factory Category.fromMap(Map<String, String> map) {
    return Category(name: map["name"] ?? "");
  }
}
