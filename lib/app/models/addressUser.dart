class Address {
  Address({this.city, this.country, this.province, this.postalCode, this.place, this.street
  });

  factory Address.fromMap(Map<String, dynamic> data, String documentId) {

    final String city = data['city'];
    final String country = data['country'];
    final String province = data['province'];
    final String postalCode = data['postalCode'];
    final String place = data['place'];
    final String street = data['street'];

    return Address(
        city: city,
        country: country,
        province: province,
        postalCode: postalCode,
        place: place,
        street: street,
    );
  }

  final String? city;
  final String? country;
  final String? province;
  final String? postalCode;
  final String? place;
  final String? street;

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country': country,
      'province': province,
      'postalCode' : postalCode,
      'place' : place,
      'street' : street,
    };
  }
}