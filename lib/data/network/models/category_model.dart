class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final int parent;
  final String description;
  final String display;
  final CategoryImage? image;
  final int menuOrder;
  final int count;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.description,
    required this.display,
    this.image,
    required this.menuOrder,
    required this.count,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      parent: json['parent'] ?? 0,
      description: json['description']?.toString() ?? '',
      display: json['display']?.toString() ?? '',
      image: (json['image'] != null && json['image'] is Map<String, dynamic>)
          ? CategoryImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      menuOrder: json['menu_order'] ?? 0,
      count: json['count'] ?? 0,
    );
  }
}

class CategoryImage {
  final int id;
  final String src;
  final String name;
  final String alt;

  CategoryImage({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      id: json['id'] ?? 0,
      src: json['src']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      alt: json['alt']?.toString() ?? '',
    );
  }
}
