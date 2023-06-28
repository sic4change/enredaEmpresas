class Province {
  Province({this.provinceId, required this.name, required this.countryId});

  factory Province.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final String? provinceId = data['provinceId'];
    final String countryId = data['countryId'];

    return Province(
        provinceId: provinceId,
        countryId: countryId,
        name: name
    );
  }

  final String name;
  final String? provinceId;
  final String countryId;


  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Province &&
            other.provinceId == provinceId);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'provinceId' : provinceId,
      'countryId' : countryId
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => provinceId.hashCode;

}
