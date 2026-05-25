class Buyer {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  Buyer({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }
}
