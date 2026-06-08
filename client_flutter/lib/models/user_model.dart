class UserModel {
  const UserModel({this.id, this.name, this.email, this.phone});

  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _toInt(json['id'] ?? json['cliente_id'] ?? json['user_id']),
      name: _toString(json['name'] ?? json['nombre'] ?? json['nombrecompleto']),
      email: _toString(json['email']),
      phone: _toString(json['phone'] ?? json['telefono']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '');
  }

  static String? _toString(dynamic value) {
    final text = value?.toString().trim();
    return (text == null || text.isEmpty) ? null : text;
  }
}
