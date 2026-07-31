class ProductDetailsResponseModel {
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
  final List<DetailProductImage> images;
  final List<DetailProductCategory> categories;
  final List<DetailProductBrand> brands;
  final String stockStatus;
  final String sku;
  final List<DetailProductAttribute> attributes;

  ProductDetailsResponseModel({
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

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    var imagesList = <DetailProductImage>[];
    if (json['images'] is List) {
      imagesList = (json['images'] as List)
          .map((img) => DetailProductImage.fromJson(img as Map<String, dynamic>))
          .toList();
    }

    var categoriesList = <DetailProductCategory>[];
    if (json['categories'] is List) {
      categoriesList = (json['categories'] as List)
          .map((cat) => DetailProductCategory.fromJson(cat as Map<String, dynamic>))
          .toList();
    }

    var brandsList = <DetailProductBrand>[];
    if (json['brands'] is List) {
      brandsList = (json['brands'] as List)
          .map((b) => DetailProductBrand.fromJson(b as Map<String, dynamic>))
          .toList();
    }

    var attributesList = <DetailProductAttribute>[];
    if (json['attributes'] is List) {
      attributesList = (json['attributes'] as List)
          .map((attr) => DetailProductAttribute.fromJson(attr as Map<String, dynamic>))
          .toList();
    }

    return ProductDetailsResponseModel(
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

class DetailProductAttribute {
  final int id;
  final String name;
  final List<String> options;

  DetailProductAttribute({
    required this.id,
    required this.name,
    required this.options,
  });

  factory DetailProductAttribute.fromJson(Map<String, dynamic> json) {
    var optionsList = <String>[];
    if (json['options'] is List) {
      optionsList = (json['options'] as List).map((o) => o.toString()).toList();
    }
    return DetailProductAttribute(
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

class DetailProductImage {
  final int id;
  final String src;
  final String name;
  final String alt;

  DetailProductImage({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory DetailProductImage.fromJson(Map<String, dynamic> json) {
    return DetailProductImage(
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

class DetailProductCategory {
  final int id;
  final String name;
  final String slug;

  DetailProductCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory DetailProductCategory.fromJson(Map<String, dynamic> json) {
    return DetailProductCategory(
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

class DetailProductBrand {
  final int id;
  final String name;
  final String slug;

  DetailProductBrand({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory DetailProductBrand.fromJson(Map<String, dynamic> json) {
    return DetailProductBrand(
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
