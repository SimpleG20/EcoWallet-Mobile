import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.password,
    super.phoneNumber,
    super.imageUrl,
    super.address,
    super.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id == null) {
      throw FormatException('Missing required field: id');
    }
    final fullName = json['fullName'];
    if (fullName == null) {
      throw FormatException('Missing required field: fullName');
    }
    final email = json['email'];
    if (email == null) {
      throw FormatException('Missing required field: email');
    }
    final password = json['password'];
    if (password == null) {
      throw FormatException('Missing required field: password');
    }
    final phoneNumber = json['phoneNumber'] ?? '';
    final imageUrl = json['imageUrl'] ?? '';
    final address = json['address'] ?? '';
    final dateOfBirthStr = json['dateOfBirth'] ?? '';

    return UserModel(
      id: id as String,
      fullName: fullName as String,
      email: email as String,
      password: password as String,
      phoneNumber: phoneNumber,
      imageUrl: imageUrl,
      address: address,
      dateOfBirth: dateOfBirthStr != '' ? DateTime.parse(dateOfBirthStr as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'imageUrl': imageUrl,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  static UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      password: user.password,
      imageUrl: user.imageUrl,
      address: user.address,
      dateOfBirth: user.dateOfBirth,
    );
  }
}
