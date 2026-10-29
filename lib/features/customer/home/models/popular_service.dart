class PopularService {
  final String id;
  final String title;
  final String description;
  final double rating;
  final String duration;
  final num startingPrice;
  final String category;
  final String imageUrl;

  const PopularService({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.duration,
    required this.startingPrice,
    required this.category,
    required this.imageUrl,
  });

  factory PopularService.fromJson(Map<String, dynamic> json) {
    return PopularService(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      duration: json['duration'] as String,
      startingPrice: json['startingPrice'] as num,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
