class Criteria {
  String type;
  String? requirementText;
  List<String>? competencies;
  double weight;
  String? competenciesNames;

  Criteria({
    required this.type,
    this.requirementText,
    this.competencies,
    required this.weight,
    this.competenciesNames

  });

  factory Criteria.fromMap(Map<String, dynamic> data) {
    return Criteria(
      type: data['type'] ?? '',
      requirementText: data['requirementText'],
      competencies: data['competencies'] != null
          ? List<String>.from(data['competencies'])
          : null,
      weight: (data['weight'] as num).toDouble(), // Handle number to double conversion
      competenciesNames: data['competenciesNames'] != null ? data['competenciesNames'] : '',
    );
  }


  Map<String, dynamic> toMap() => {
    'type': type,
    'requirementText': requirementText,
    'competencies': competencies,
    'weight': weight,
  };

}