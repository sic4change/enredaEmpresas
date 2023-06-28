class AddressResource {
  AddressResource({this.city, required this.country, this.province, this.place,
  });

  factory AddressResource.fromMap(Map<String, dynamic> data, String documentId) {

    final String city = data['city'];
    final String country = data['country'];
    final String province = data['province'];
    final String place = data['place'];

    return AddressResource(
        city: city,
        country: country,
        province: province,
        place: place,
    );
  }

  final String? city;
  final String country;
  final String? province;
  final String? place;

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country': country,
      'province': province,
      'place' : place,
    };
  }
}