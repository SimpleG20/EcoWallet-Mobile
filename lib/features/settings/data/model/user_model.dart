import 'package:eco_wallet/features/settings/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.encryptedPassword,
    required super.address,
    required super.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      encryptedPassword: json['encryptedPassword'] as String,
      address: json['address'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'encryptedPassword': encryptedPassword,
      'address': address ?? '',
      'dateOfBirth': dateOfBirth?.toIso8601String() ?? '',
    };
  }
}
