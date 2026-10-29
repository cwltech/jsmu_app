class ServiceItemModel {
  final String id;
  final String badge;
  final String title;
  final String duration;
  final double rating;
  final String reviewsCount;
  final num price;
  final num originalPrice;
  final int discountPercent;
  final List<String> features;
  final String imageUrl;

  const ServiceItemModel({
    required this.id,
    required this.badge,
    required this.title,
    required this.duration,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.features,
    required this.imageUrl,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'] as String,
      badge: json['badge'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'] as String,
      price: json['price'] as num,
      originalPrice: json['originalPrice'] as num,
      discountPercent: json['discountPercent'] as int,
      features: (json['features'] as List).map((e) => e.toString()).toList(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class CartItemModel {
  final ServiceItemModel service;
  int quantity;

  CartItemModel({required this.service, this.quantity = 1});

  num get totalPrice => service.price * quantity;
  num get totalSavings => (service.originalPrice - service.price) * quantity;
}
