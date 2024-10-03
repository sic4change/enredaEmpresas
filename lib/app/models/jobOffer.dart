import 'package:enreda_empresas/app/models/jobOfferApplication.dart';

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
    this.status,
    this.organizerId,
    this.applications,
  });

  factory JobOffer.fromMap(Map<String, dynamic> data, String documentId) {

    final String resourceId = data['resourceId'];
    final String jobOfferId = data['jobOfferId'];
    final String status = data['status'];
    final String organizerId = data['organizerId'];
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

    List<String>? applications = [];
    if (data['applications'] != null) {
      data['applications'].forEach((application) {applications.add(application.toString());});
    }

    return JobOffer(
        jobOfferId: jobOfferId,
        resourceId: resourceId,
        status: status,
        organizerId: organizerId,
        responsibilities: responsibilities,
        functions: functions,
        otherRequirements: otherRequirements,
        createdate: createdate,
        criteria: criteria,
        applications: applications

    );
  }

  final String? resourceId;
  final String? jobOfferId;
  final String? status;
  final String? organizerId;
  final String? responsibilities;
  final String? functions;
  final String? otherRequirements;
  final DateTime createdate;
  final List<Criteria>? criteria;
  final List<String>? applications;

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
      'status': status,
      'organizerId': organizerId,
      'responsibilities': responsibilities,
      'functions': functions,
      'otherRequirements': otherRequirements,
      'createdate': createdate,
      'criteria': List<dynamic>.from(criteria!.map((x) => x.toMap())),
      'applications': applications
    };
  }

  JobOffer copyWith({
    String? resourceId,
    String? jobOfferId,
    String? status,
    String? organizerId,
    String? responsibilities,
    String? functions,
    String? otherRequirements,
    DateTime? createdate,
    List<Criteria>? criteria,
    List<String>? applications

  }) {
    return JobOffer(
        resourceId: resourceId?? this.resourceId,
        jobOfferId: jobOfferId?? this.jobOfferId,
        status: status?? this.status,
        organizerId: organizerId?? this.organizerId,
        responsibilities: responsibilities?? this.responsibilities,
        functions: functions?? this.functions,
        otherRequirements: otherRequirements?? this.otherRequirements,
        createdate: createdate?? this.createdate,
        criteria: criteria?? this.criteria,
        applications: applications?? this.applications
    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => resourceId.hashCode;


}
