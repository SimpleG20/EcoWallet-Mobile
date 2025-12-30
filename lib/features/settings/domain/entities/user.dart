import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String encryptedPassword;
  final String? address;
  final DateTime? dateOfBirth;

  const User({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.encryptedPassword,
    this.address,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [fullName, email, phoneNumber, address, dateOfBirth];
}
