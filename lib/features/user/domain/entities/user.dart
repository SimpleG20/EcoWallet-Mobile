import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? imageUrl;
  final String? address;
  final DateTime? dateOfBirth;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.imageUrl,
    this.address,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        password,
        imageUrl,
        address,
        dateOfBirth,
      ];

  User copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
    String? imageUrl,
    String? address,
    DateTime? dateOfBirth,
  }) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
