class CertificationRequest {
  CertificationRequest({
    this.certificationRequestId,
    required this.email,
    required this.certifierName,
    required this.certifierCompany,
    required this.certifierPosition,
    required this.competencyId,
    required this.competencyName,
    required this.unemployedRequesterId,
    required this.unemployedRequesterName,
    required this.certified,
    required this.referenced,
    this.phone,
  });

  factory CertificationRequest.fromMap(Map<String, dynamic> data, String documentId) {
    final String certificationRequestId = data['certificationRequestId'];
    final String email = data['email'];
    final String certifierName = data['certifierName'];
    final String certifierCompany = data['certifierCompany'];
    final String certifierPosition = data['certifierPosition'];
    final String phone = data['phone'];
    final String competencyId = data['competencyId'];
    final String competencyName = data['competencyName'];
    final String unemployedRequesterId = data['unemployedRequesterId'];
    final String unemployedRequesterName = data['unemployedRequesterName'];
    final bool certified = data['certified'];
    final bool referenced = data['referenced'];

    return CertificationRequest(
      certificationRequestId: certificationRequestId,
      email: email,
      certifierName: certifierName,
      certifierCompany: certifierCompany,
      certifierPosition: certifierPosition,
      phone: phone,
      competencyId: competencyId,
      competencyName: competencyName,
      unemployedRequesterId: unemployedRequesterId,
      unemployedRequesterName: unemployedRequesterName,
      certified: certified,
      referenced: referenced,
    );
  }

  final String? certificationRequestId;
  final String email;
  final String? phone;
  late String certifierName;
  late String certifierCompany;
  late String certifierPosition;
  final String competencyId;
  final String competencyName;
  final String unemployedRequesterId;
  final String unemployedRequesterName;
  final bool certified;
  final bool referenced;

  Map<String, dynamic> toMap() {
    return {
      'email' : email,
      'phone' : phone,
      'certifierName' : certifierName,
      'certifierCompany' : certifierCompany,
      'certifierPosition' : certifierPosition,
      'competencyId' : competencyId,
      'competencyName' : competencyName,
      'unemployedRequesterId' : unemployedRequesterId,
      'unemployedRequesterName' : unemployedRequesterName,
      'certified' : certified,
      'referenced' : referenced,
    };
  }
}
