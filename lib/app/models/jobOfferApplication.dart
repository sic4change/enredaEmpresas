class JobOfferApplication {
  String jobOfferApplicationId;
  String jobOfferId;
  String resourceId;
  String userId;
  String? status;
  double? match;
  DateTime? createdate;
  final Map<String, int> evaluations;
  final Map<String, int> points;

  JobOfferApplication({
    required this.jobOfferApplicationId,
    required this.jobOfferId,
    required this.resourceId,
    required this.userId,
    this.status,
    this.match,
    this.createdate,
    this.evaluations = const {},
    this.points = const {},

  });

  factory JobOfferApplication.fromMap(Map<String, dynamic> data, String documentId) {

    Map<String, int> evaluations = {};
    if (data['evaluations'] != null) {
      (data['evaluations'] as Map<String, dynamic>).forEach((key, value) {
        evaluations[key] = value;
      });
    }

    Map<String, int> points = {};
    if (data['points'] != null) {
      (data['points'] as Map<String, dynamic>).forEach((key, value) {
        points[key] = value;
      });
    }

    return JobOfferApplication(
      jobOfferApplicationId: data['jobOfferApplicationId'] ?? '',
      createdate: data['createdate']?.toDate(),
      jobOfferId: data['jobOfferId'] ?? '',
      resourceId: data['resourceId'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? '',
      match: data['match'] ?? 0,
      evaluations: evaluations,
      points: points,
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
    'evaluations': evaluations,
    'points': points,
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