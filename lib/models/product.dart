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
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toInt(),
      originalPrice: json['original_price'] != null ? (json['original_price'] as num).toInt() : null,
      stock: (json['stock'] as num).toInt(),
      category: json['category'] as String? ?? 'Umum',
      images: parsedImages,
      variants: parsedVariants,
      specs: (json['specs'] as Map<String, dynamic>?) ?? {},
      tags: parsedTags,
      weight: (json['weight'] as num? ?? 0).toInt(),
      totalSold: (json['total_sold'] as num? ?? 0).toInt(),
      rating: (json['rating'] as num? ?? 5.0).toDouble(),
      reviewCount: (json['review_count'] as num? ?? 0).toInt(),
      storeId: (json['store_id'] as num? ?? 0).toInt(),
      storeName: json['store_name'] as String? ?? 'Toko ASFI',
      storeSlug: json['store_slug'] as String? ?? '',
      city: json['city'] as String?,
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
