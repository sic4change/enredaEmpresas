import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';

class Competency {
  Competency({
    this.id,
    required this.name,
    required this.description,
    this.badgesImages = const {},
    this.testQuestions = const [],
    this.trickQuestion,
  });

  factory Competency.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = data['id'];
    final String name = data['name'];
    final String description = data['description'];

    Map<String, String> badgesImages = {};
    if (data['badgesImages'] != null) {
      badgesImages[StringConst.BADGE_EMPTY] =
          data['badgesImages'][StringConst.BADGE_EMPTY];
      badgesImages[StringConst.BADGE_IDENTIFIED] =
          data['badgesImages'][StringConst.BADGE_IDENTIFIED];
      badgesImages[StringConst.BADGE_VALIDATED] =
          data['badgesImages'][StringConst.BADGE_VALIDATED];
      badgesImages[StringConst.BADGE_PROCESSING] =
      data['badgesImages'][StringConst.BADGE_VALIDATED];
      badgesImages[StringConst.BADGE_CERTIFIED] =
          data['badgesImages'][StringConst.BADGE_CERTIFIED];
    }

    List<String> testQuestions = [];
    if (data['testQuestions'] != null) {
      List<dynamic> list = data['testQuestions'];
      list.forEach((element) {
        testQuestions.add(element);
      });
    }

    final String? trickQuestion = data['trickQuestion'];

    return Competency(
      id: id,
      name: name,
      description: description,
      badgesImages: badgesImages,
      testQuestions: testQuestions,
      trickQuestion: trickQuestion,
    );
  }

  final String? id;
  final String name;
  final String description;
  final Map<String, String> badgesImages;
  final List<String> testQuestions;
  final String? trickQuestion;

  final ValueNotifier<bool> selected = ValueNotifier<bool>(false);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'badgesImages': badgesImages,
      'testQuestions': testQuestions,
      'trickQuestion': trickQuestion,
    };
  }
}
