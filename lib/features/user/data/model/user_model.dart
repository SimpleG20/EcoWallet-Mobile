import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.encryptedPassword,
    super.phoneNumber,
    super.imageUrl,
    super.address,
    super.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      encryptedPassword: json['encryptedPassword'] as String,
      imageUrl: json['imageUrl'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'encryptedPassword': encryptedPassword,
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
      encryptedPassword: user.encryptedPassword,
      imageUrl: user.imageUrl,
      address: user.address,
      dateOfBirth: user.dateOfBirth,
    );
  }
}
