class JobOffer {
  JobOffer({
    this.jobOfferId,
    this.resourceId,
    this.responsibilities,
    this.functions,
    this.otherRequirements,
    required this.createdate,
  });

  factory JobOffer.fromMap(Map<String, dynamic> data, String documentId) {

    final String resourceId = data['resourceId'];
    final String? responsibilities = data['responsibilities'];
    final String? functions = data['functions'];
    final String? otherRequirements = data['otherRequirements'];
    final DateTime createdate = data['createdate'].toDate();


    return JobOffer(
        jobOfferId: documentId,
        resourceId: resourceId,
        responsibilities: responsibilities,
        functions: functions,
        otherRequirements: otherRequirements,
        createdate: createdate

    );
  }

  final String? resourceId;
  final String? jobOfferId;
  final String? responsibilities;
  final String? functions;
  final String? otherRequirements;
  final DateTime createdate;

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
      'responsibilities': responsibilities,
      'functions': functions,
      'otherRequirements': otherRequirements,
      'createdate': createdate
    };
  }

  JobOffer copyWith({
    String? resourceId,
    String? jobOfferId,
    String? responsibilities,
    String? functions,
    String? otherRequirements,
    DateTime? createdate


  }) {
    return JobOffer(
        resourceId: resourceId?? this.resourceId,
        jobOfferId: jobOfferId?? this.jobOfferId,
        responsibilities: responsibilities?? this.responsibilities,
        functions: functions?? this.functions,
        otherRequirements: otherRequirements?? this.otherRequirements,
        createdate: createdate?? this.createdate

    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => resourceId.hashCode;


}
