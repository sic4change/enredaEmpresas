class JobOfferApplication {
  String jobOfferApplicationId;
  String jobOfferId;
  String resourceId;
  String userId;
  String? status;
  num? match;
  DateTime? createdate;

  JobOfferApplication({
    required this.jobOfferApplicationId,
    required this.jobOfferId,
    required this.resourceId,
    required this.userId,
    this.status,
    this.match,
    this.createdate

  });

  factory JobOfferApplication.fromMap(Map<String, dynamic> data, String documentId) {
    return JobOfferApplication(
      jobOfferApplicationId: data['jobOfferApplicationId'] ?? '',
      createdate: data['createdate']?.toDate(),
      jobOfferId: data['jobOfferId'] ?? '',
      resourceId: data['resourceId'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? '',
      match: data['match'] ?? 0 as num,
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