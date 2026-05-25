class Product {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final int price;
  final int? originalPrice;
  final int stock;
  final String category;
  final List<String> images;
  final List<String> variants;
  final Map<String, dynamic> specs;
  final List<String> tags;
  final int weight;
  final int totalSold;
  final double rating;
  final int reviewCount;
  final int storeId;
  final String storeName;
  final String storeSlug;
  final String? city;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.originalPrice,
    required this.stock,
    required this.category,
    required this.images,
    required this.variants,
    required this.specs,
    required this.tags,
    required this.weight,
    required this.totalSold,
    required this.rating,
    required this.reviewCount,
    required this.storeId,
    required this.storeName,
    required this.storeSlug,
    this.city,
  });

  static int _parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    var imgsList = json['images'];
    List<String> parsedImages = [];
    if (imgsList is List) {
      parsedImages = imgsList.map((e) => e.toString()).toList();
    }

    var varsList = json['variants'];
    List<String> parsedVariants = [];
    if (varsList is List) {
      parsedVariants = varsList.map((e) => e.toString()).toList();
    }

    var tagsList = json['tags'];
    List<String> parsedTags = [];
    if (tagsList is List) {
      parsedTags = tagsList.map((e) => e.toString()).toList();
    }

    return Product(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      price: _parseInt(json['price']),
      originalPrice: json['original_price'] != null ? _parseInt(json['original_price']) : null,
      stock: _parseInt(json['stock']),
      category: json['category']?.toString() ?? 'Umum',
      images: parsedImages,
      variants: parsedVariants,
      specs: (json['specs'] as Map<String, dynamic>?) ?? {},
      tags: parsedTags,
      weight: _parseInt(json['weight'], 0),
      totalSold: _parseInt(json['total_sold'], 0),
      rating: _parseDouble(json['rating'], 5.0),
      reviewCount: _parseInt(json['review_count'], 0),
      storeId: _parseInt(json['store_id'], 0),
      storeName: json['store_name']?.toString() ?? 'Toko ASFI',
      storeSlug: json['store_slug']?.toString() ?? '',
      city: json['city']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'stock': stock,
      'category': category,
      'images': images,
      'variants': variants,
      'specs': specs,
      'tags': tags,
      'weight': weight,
      'total_sold': totalSold,
      'rating': rating,
      'review_count': reviewCount,
      'store_id': storeId,
      'store_name': storeName,
      'store_slug': storeSlug,
      'city': city,
    };
  }
}
