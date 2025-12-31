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
}
