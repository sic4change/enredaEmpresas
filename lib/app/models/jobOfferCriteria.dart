import 'package:enreda_empresas/app/models/jobOfferApplication.dart';

import 'criteria.dart';

class JobOfferCriteria {
  String? criteriaId;
  String? name;
  String? type;
  final Map<int, String> punctuation;

  JobOfferCriteria({
    this.criteriaId,
    this.name,
    this.type,
    this.punctuation = const {},
  });

  factory JobOfferCriteria.fromMap(Map<String, dynamic> data, String documentId) {

    final String criteriaId = data['criteriaId'];
    final String name = data['name'];
    final String type = data['type'];

    Map<int, String> punctuation = {};
    if (data['punctuation'] != null) {
      (data['punctuation'] as Map<String, dynamic>).forEach((key, value) {
        // Attempt to parse the key as an integer
        int? intKey = int.tryParse(key);
        if (intKey != null && value is String) {
          punctuation[intKey] = value;
        }
      });
    }

    return JobOfferCriteria(
        criteriaId: criteriaId,
        name: name,
        type: type,
        punctuation: punctuation
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JobOfferCriteria &&
            other.criteriaId == criteriaId);
  }

  Map<String, dynamic> toMap() {
    return {
      'criteriaId': criteriaId,
      'name': name,
      'type': type,
      'punctuation': punctuation
    };
  }

  JobOfferCriteria copyWith({
    String? criteriaId,
    String? name,
    String? type,
    Map<int, String>? punctuation

  }) {
    return JobOfferCriteria(
        criteriaId: criteriaId?? this.criteriaId,
        name: name?? this.name,
        type: type?? this.type,
        punctuation: punctuation?? this.punctuation
    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => criteriaId.hashCode;


}
