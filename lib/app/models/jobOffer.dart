import 'criteria.dart';

class JobOffer {
  JobOffer({
    this.jobOfferId,
    this.resourceId,
    this.responsibilities,
    this.functions,
    this.otherRequirements,
    required this.createdate,
    this.criteria,
  });

  factory JobOffer.fromMap(Map<String, dynamic> data, String documentId) {

    final String resourceId = data['resourceId'];
    final String jobOfferId = data['jobOfferId'];
    final String? responsibilities = data['responsibilities'];
    final String? functions = data['functions'];
    final String? otherRequirements = data['otherRequirements'];
    final DateTime createdate = data['createdate'].toDate();

    List<Criteria> criteria = [];
    if (data['criteria'] != null) {
      try {
        criteria = (data['criteria'] as List)
            .map((item) => Criteria.fromMap(item))
            .toList();
      } catch (e) {
        criteria = [];
      }
    }

    return JobOffer(
        jobOfferId: jobOfferId,
        resourceId: resourceId,
        responsibilities: responsibilities,
        functions: functions,
        otherRequirements: otherRequirements,
        createdate: createdate,
        criteria: criteria

    );
  }

  final String? resourceId;
  final String? jobOfferId;
  final String? responsibilities;
  final String? functions;
  final String? otherRequirements;
  final DateTime createdate;
  final List<Criteria>? criteria;

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JobOffer &&
            other.jobOfferId == jobOfferId);
  }

  Map<String, dynamic> toMap() {
    return {
      'resourceId': resourceId,
      'jobOfferId': jobOfferId,
      'responsibilities': responsibilities,
      'functions': functions,
      'otherRequirements': otherRequirements,
      'createdate': createdate,
      'criteria': List<dynamic>.from(criteria!.map((x) => x.toMap())),
    };
  }

  JobOffer copyWith({
    String? resourceId,
    String? jobOfferId,
    String? academicQualifications,
    String? experienceLevel,
    String? languageSkills,
    String? responsibilities,
    String? functions,
    String? otherRequirements,
    DateTime? createdate,
    List<Criteria>? criteria,


  }) {
    return JobOffer(
        resourceId: resourceId?? this.resourceId,
        jobOfferId: jobOfferId?? this.jobOfferId,
        responsibilities: responsibilities?? this.responsibilities,
        functions: functions?? this.functions,
        otherRequirements: otherRequirements?? this.otherRequirements,
        createdate: createdate?? this.createdate,
        criteria: criteria?? this.criteria
    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => resourceId.hashCode;


}
