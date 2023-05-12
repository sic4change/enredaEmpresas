class SpecificInterest {
  SpecificInterest({this.interestId, required this.name, this.specificInterestId,});

  final String? interestId;
  final String name;
  final String? specificInterestId;

  factory SpecificInterest.fromMap(Map<String, dynamic> data, String documentId) {

    return SpecificInterest(
      specificInterestId: data['specificInterestId'],
      interestId: data['interestId'],
      name: data['name'],
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpecificInterest &&
            other.specificInterestId == specificInterestId);
  }

  Map<String, dynamic> toMap() {
    return {
      'interestId': interestId,
      'name': name,
      'specificInterestId' : specificInterestId,
    };
  }
}