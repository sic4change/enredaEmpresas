import 'addressUser.dart';

class MentorUser {
  MentorUser({
    required this.email,
    this.firstName,
    this.lastName,
    this.userId,
    this.country,
    this.province,
    this.city,
    this.address,
    this.role,
    this.phone,
    this.postalCode,
  });

  String? email;
  final String? firstName;
  final String? lastName;
  String? userId;
  final String? country;
  final String? province;
  final String? city;
  final Address? address;
  final String? role;
  final String? phone;
  final String? postalCode;

  factory MentorUser.fromMap(Map<String, dynamic> data, String documentId) {

    final Address? address = new Address(
        country: data['address']['country'],
        province: data['address']['province'],
        city: data['address']['city'],
        postalCode: data['address']['postalCode']
    );

    return MentorUser(
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      userId: data['userId'],
      address: address,
      role: data['role'],
      phone: data['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userId': userId,
      'address': address?.toMap(),
      'role' : role,
      'phone': phone,
    };
  }
}