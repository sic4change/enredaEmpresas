class Gender {
  Gender({this.genderId, required this.name});

  final String? genderId;
  final String name;

  factory Gender.fromMap(Map<String, dynamic> data, String documentId) {
    return Gender(
      genderId: data['genderId'],
      name: data['name'],
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Gender &&
            other.genderId == genderId);
  }

  Map<String, dynamic> toMap() {
    return {
      'genderId': genderId,
      'name': name,
    };
  }
}
