
import 'package:enreda_empresas/app/models/profilepic.dart';

class Certificate {
  Certificate({
    required this.name,
    this.certificateId,
    required this.resource,
    required this.user,
    this.resourceName,
    this.userFirstName,
    this.userLastName,
    required this.date,
    required this.finished,
    this.certificatePic,
    this.certificate,
  });

  factory Certificate.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final String? certificateId = data['certificateId'];
    final String resource = data['resource'];
    final String user = data['user'];
    final String? resourceName = data['resourceName'];
    final String? userFirstName = data['userFirstName'];
    final String? userLastName = data['userLastName'];
    final DateTime date = data['date'].toDate();
    final bool finished = data['finished'];
    String certificate;
    try {
      certificate = data['certificatePic']['src'];
    } catch (e) {
      certificate = '';
    }
    final ProfilePic certificatePic = new ProfilePic(
        src: certificate, title: 'certificate.pdf'
    );



    return Certificate(
        certificateId: documentId,
        name: name,
        resource: resource,
        user: user,
        resourceName : resourceName,
        userFirstName: userFirstName,
        userLastName: userLastName,
        date: date,
        finished: finished,
      certificatePic: certificatePic,
      certificate: certificate,

    );
  }

  final String? certificateId;
  final String name;
  final String resource;
  final String user;
  String? resourceName;
  String? userFirstName;
  String? userLastName;
  final DateTime date;
  final bool finished;
  final ProfilePic? certificatePic;
  final String? certificate;

  Map<String, dynamic> toMap() {
    return {
      'certificateId': certificateId,
      'name': name,
      'resource': resource,
      'user': user,
      'resourceName': resourceName,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'date': date,
      'finished': finished,
    };
  }

}
