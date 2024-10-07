import 'criteria.dart';

class JobOfferApplication {
  String jobOfferApplicationId;
  String jobOfferId;
  String resourceId;
  String userId;
  String? status;
  double? match;
  DateTime? createdate;
  List<Criteria>? criteria;

  JobOfferApplication({
    required this.jobOfferApplicationId,
    required this.jobOfferId,
    required this.resourceId,
    required this.userId,
    this.status,
    this.match,
    this.createdate,
    this.criteria,

  });

  factory JobOfferApplication.fromMap(Map<String, dynamic> data, String documentId) {
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

    return JobOfferApplication(
      jobOfferApplicationId: data['jobOfferApplicationId'] ?? '',
      createdate: data['createdate']?.toDate(),
      jobOfferId: data['jobOfferId'] ?? '',
      resourceId: data['resourceId'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? '',
      match: data['match'] ?? 0,
      criteria: criteria
    );
  }

  Map<String, dynamic> toMap() => {
    'jobOfferApplicationId': jobOfferApplicationId,
    'createdate': createdate,
    'jobOfferId': jobOfferId,
    'resourceId': resourceId,
    'userId': userId,
    'status': status,
    'match': match,
    'criteria': criteria
  };

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JobOfferApplication &&
            other.jobOfferApplicationId == jobOfferApplicationId);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => resourceId.hashCode;

}