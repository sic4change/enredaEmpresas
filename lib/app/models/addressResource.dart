class AddressResource {
  AddressResource({this.city, required this.country, this.province, this.place, this.street,
  });

  factory AddressResource.fromMap(Map<String, dynamic> data, String documentId) {

    final String city = data['city'];
    final String country = data['country'];
    final String province = data['province'];
    final String place = data['place'];
    final String street = data['street'];

    return AddressResource(
        city: city,
        country: country,
        province: province,
        place: place,
        street: street
    );
  }

  final String? city;
  final String country;
  final String? province;
  final String? place;
  final String? street;

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country': country,
      'province': province,
      'place' : place,
      'street' : street,
    };
  }
}