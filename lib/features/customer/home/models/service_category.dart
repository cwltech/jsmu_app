class ServiceCategory {
  final String id;
  final String name;
  final String iconKey;
  final String? imageUrl;
  final String? assetPath;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    this.imageUrl,
    this.assetPath,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      iconKey: (json['icon'] ?? 'plumbing') as String,
      imageUrl: json['imageUrl'] as String?,
      assetPath: json['assetPath'] as String?,
    );
  }
}
