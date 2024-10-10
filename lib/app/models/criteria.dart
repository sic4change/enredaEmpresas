class Criteria {
  String criteriaId;
  String? requirementText;
  List<String>? competencies;
  double weight;
  String? competenciesNames;

  Criteria({
    required this.criteriaId,
    this.requirementText,
    this.competencies,
    required this.weight,
    this.competenciesNames

  });

  factory Criteria.fromMap(Map<String, dynamic> data) {
    return Criteria(
      criteriaId: data['criteriaId'] ?? '',
      requirementText: data['requirementText'],
      competencies: data['competencies'] != null
          ? List<String>.from(data['competencies'])
          : null,
      weight: data['weight'], // Handle number to double conversion
      competenciesNames: data['competenciesNames'] != null ? data['competenciesNames'] : '',
    );
  }


  Map<String, dynamic> toMap() => {
    'criteriaId': criteriaId,
    'requirementText': requirementText,
    'competencies': competencies,
    'weight': weight,
  };

}