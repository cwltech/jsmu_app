class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? location;
  final String role; // 'customer' or 'partner'
  final bool isVerified;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.location,
    this.role = 'customer',
    this.isVerified = true,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'usr_1',
      name: json['name'] as String? ?? 'User',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      location: json['location'] as String?,
      role: json['role'] as String? ?? 'customer',
      isVerified: json['isVerified'] as bool? ?? true,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? location,
    String? role,
    bool? isVerified,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'location': location,
      'role': role,
      'isVerified': isVerified,
      'avatarUrl': avatarUrl,
    };
  }
}
