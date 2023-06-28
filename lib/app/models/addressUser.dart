class Address {
  Address({this.city, this.country, this.province, this.postalCode, this.place,
  });

  factory Address.fromMap(Map<String, dynamic> data, String documentId) {

    final String city = data['city'];
    final String country = data['country'];
    final String province = data['province'];
    final String postalCode = data['postalCode'];
    final String place = data['place'];


    return Address(
        city: city,
        country: country,
        province: province,
        postalCode: postalCode,
        place: place,
    );
  }

  final String? city;
  final String? country;
  final String? province;
  final String? postalCode;
  final String? place;

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country': country,
      'province': province,
      'postalCode' : postalCode,
      'place' : place,
    };
  }
}