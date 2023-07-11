import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {
  Experience({
    this.id,
    required this.userId,
    required this.type,
    this.subtype,
    this.activity,
    this.activityRole,
    this.activityLevel,
    this.professionActivities = const [],
    this.peopleAffected,
    this.organization,
    this.position,
    this.professionActivitiesText,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.workType,
    required this.context,
    required this.contextPlace,
  });

  final String? id;
  final String userId;
  final String type;
  final String? subtype;
  final String? activity;
  final String? activityRole;
  final String? activityLevel;
  final List<String> professionActivities;
  final String? peopleAffected;
  final String? organization;
  final String? position;
  final String? professionActivitiesText;
  final Timestamp startDate;
  final Timestamp? endDate;
  final String location;
  final String workType;
  final String context;
  final String contextPlace;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'subtype': subtype,
      'activity': activity,
      'activityRole': activityRole,
      'activityLevel': activityLevel,
      'professionActivities': professionActivities,
      'peopleAffected': peopleAffected,
      'organization': organization,
      'position': position,
      'professionActivitiesText': professionActivitiesText,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'workType': workType,
      'context': context,
      'contextPlace': contextPlace,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = data['id'];
    final String userId = data['userId'];
    final String type = data['type'];
    final String? subtype = data['subtype'];
    final String? activity = data['activity'];
    final String? activityRole = data['activityRole'];
    final String? activityLevel = data['activityLevel'];
    final String? peopleAffected = data['peopleAffected'];
    final String? organization = data['organization'];
    final String? position = data['position'];
    final String? professionActivitiesText = data['professionActivitiesText'];
    final Timestamp startDate = data['startDate'];
    final Timestamp? endDate = data['endDate'];
    final String location = data['location'];
    final String workType = data['workType'];
    final String context = data['context'];
    final String contextPlace = data['contextPlace'];

    List<String> professionActivities = [];
    if (data['professionActivities'] != null) {
      List<dynamic> list = data['professionActivities'];
      list.forEach((element) {
        professionActivities.add(element);
      });
    }

    return Experience(
      id: id,
      userId: userId,
      type: type,
      subtype: subtype,
      activity: activity,
      activityRole: activityRole,
      activityLevel: activityLevel,
      professionActivities: professionActivities,
      peopleAffected: peopleAffected,
      organization: organization,
      position: position,
      professionActivitiesText: professionActivitiesText,
      startDate: startDate,
      endDate: endDate,
      location: location,
      workType: workType,
      context: context,
      contextPlace: contextPlace,
    );
  }
}
