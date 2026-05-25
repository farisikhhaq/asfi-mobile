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
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
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
