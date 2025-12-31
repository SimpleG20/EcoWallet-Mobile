import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String encryptedPassword;
  final String? phoneNumber;
  final String? imageUrl;
  final String? address;
  final DateTime? dateOfBirth;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.encryptedPassword,
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
        encryptedPassword,
        imageUrl,
        address,
        dateOfBirth,
      ];
}
