class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String price;
  final String regularPrice;
  final String salePrice;
  final bool onSale;
  final bool purchasable;
  final String averageRating;
  final int ratingCount;
  final List<ProductImage> images;
  final List<ProductCategory> categories;
  final List<ProductBrand> brands;
  final String stockStatus;
  final String sku;
  final List<ProductAttribute> attributes;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    required this.purchasable,
    required this.averageRating,
    required this.ratingCount,
    required this.images,
    required this.categories,
    required this.brands,
    required this.stockStatus,
    required this.sku,
    required this.attributes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Safely parse images
    var imagesList = <ProductImage>[];
    if (json['images'] is List) {
      imagesList = (json['images'] as List)
          .map((img) => ProductImage.fromJson(img as Map<String, dynamic>))
          .toList();
    }

    // Safely parse categories
    var categoriesList = <ProductCategory>[];
    if (json['categories'] is List) {
      categoriesList = (json['categories'] as List)
          .map((cat) => ProductCategory.fromJson(cat as Map<String, dynamic>))
          .toList();
    }

    // Safely parse brands
    var brandsList = <ProductBrand>[];
    if (json['brands'] is List) {
      brandsList = (json['brands'] as List)
          .map((b) => ProductBrand.fromJson(b as Map<String, dynamic>))
          .toList();
    }

    // Safely parse attributes
    var attributesList = <ProductAttribute>[];
    if (json['attributes'] is List) {
      attributesList = (json['attributes'] as List)
          .map((attr) => ProductAttribute.fromJson(attr as Map<String, dynamic>))
          .toList();
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      regularPrice: json['regular_price']?.toString() ?? '',
      salePrice: json['sale_price']?.toString() ?? '',
      onSale: json['on_sale'] ?? false,
      purchasable: json['purchasable'] ?? true,
      averageRating: json['average_rating']?.toString() ?? '0.00',
      ratingCount: json['rating_count'] ?? 0,
      images: imagesList,
      categories: categoriesList,
      brands: brandsList,
      stockStatus: json['stock_status']?.toString() ?? 'instock',
      sku: json['sku']?.toString() ?? '',
      attributes: attributesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'purchasable': purchasable,
      'average_rating': averageRating,
      'rating_count': ratingCount,
      'images': images.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'brands': brands.map((e) => e.toJson()).toList(),
      'stock_status': stockStatus,
      'sku': sku,
      'attributes': attributes.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductAttribute {
  final int id;
  final String name;
  final List<String> options;

  ProductAttribute({
    required this.id,
    required this.name,
    required this.options,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    var optionsList = <String>[];
    if (json['options'] is List) {
      optionsList = (json['options'] as List).map((o) => o.toString()).toList();
    }
    return ProductAttribute(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      options: optionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'options': options,
    };
  }
}

class ProductImage {
  final int id;
  final String src;
  final String name;
  final String alt;

  ProductImage({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      src: json['src']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      alt: json['alt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'src': src,
      'name': name,
      'alt': alt,
    };
  }
}

class ProductCategory {
  final int id;
  final String name;
  final String slug;

  ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

class ProductBrand {
  final int id;
  final String name;
  final String slug;

  ProductBrand({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
