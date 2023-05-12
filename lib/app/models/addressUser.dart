class Address {
  Address({this.city, this.country, this.province, this.postalCode,
  });

  factory Address.fromMap(Map<String, dynamic> data, String documentId) {

    final String city = data['city'];
    final String country = data['country'];
    final String province = data['province'];
    final String postalCode = data['postalCode'];

    return Address(
        city: city,
        country: country,
        province: province,
        postalCode: postalCode
    );
  }

  final String? city;
  final String? country;
  final String? province;
  final String? postalCode;

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country': country,
      'province': province,
      'postalCode' : postalCode,
    };
  }
}