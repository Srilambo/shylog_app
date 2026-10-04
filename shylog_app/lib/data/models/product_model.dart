class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final List<String> sizes; // e.g. "4-6 Y", "6-8 Y", "8-10 Y", "10-12 Y", "12-14 Y"
  final List<String> colors; // Hex strings or color names
  final double rating;
  final int numReviews;
  final int stock;
  final bool isNewArrival;
  final bool isBestSeller;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.sizes,
    required this.colors,
    this.rating = 4.5,
    this.numReviews = 12,
    this.stock = 25,
    this.isNewArrival = false,
    this.isBestSeller = false,
  });

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((price - discountPrice!) / price) * 100).round();
  }

  double get effectivePrice => discountPrice ?? price;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] is Map ? json['category']['name'] : (json['category'] ?? ''),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      sizes: (json['sizes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['6-8 Y', '8-10 Y', '10-12 Y'],
      colors: (json['colors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Navy', 'White', 'Black'],
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      numReviews: json['numReviews'] ?? 10,
      stock: json['stock'] ?? 20,
      isNewArrival: json['isNewArrival'] ?? false,
      isBestSeller: json['isBestSeller'] ?? false,
    );
  }
}
