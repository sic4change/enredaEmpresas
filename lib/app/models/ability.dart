class Ability {
  Ability({this.abilityId, required this.name});
  final String? abilityId;
  final String name;

  factory Ability.fromMap(Map<String, dynamic> data, String documentId) {
    return Ability(
      abilityId: data['abilityId'],
      name: data['name'],

    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Ability &&
            other.abilityId == abilityId);
  }

  Map<String, dynamic> toMap() {
    return {
      'abilityId': abilityId,
      'name': name,
    };
  }
}