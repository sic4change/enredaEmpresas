class City {
  City({this.cityId, required this.name, required this.countryId, required this.provinceId});

  factory City.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final String? cityId = data['cityId'];
    final String? countryId = data['countryId'];
    final String provinceId = data['provinceId'];

    return City(
      cityId: cityId,
      name: name,
      provinceId: provinceId,
      countryId: countryId,
    );
  }

  final String name;
  final String? cityId;
  final String provinceId;
  final String? countryId;

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is City &&
            other.cityId == cityId);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cityId' : cityId,
      'countryId' : countryId,
      'provinceId' : provinceId,
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => cityId.hashCode;

}