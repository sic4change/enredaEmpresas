import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatQuestion {
  ChatQuestion(
      {/*required*/ this.id,
      required this.userId,
      required this.questionId,
      required this.date,
      this.userResponse,
      required this.show});

  final String? id;
  final String userId;
  final String questionId;
  final Timestamp date;
  final String? userResponse;
  final bool show;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'questionId': questionId,
      'date': date,
      'userResponse': userResponse,
      'show': show,
    };
  }

  factory ChatQuestion.fromMap(Map<String, dynamic> data, String documentId) {
    final String? id = data['id'];
    final String userId = data['userId'];
    final String questionId = data['questionId'];
    final Timestamp date = data['date'];
    final String? userResponse = data['userResponse'];
    final bool show = data['show'];

    return ChatQuestion(
        id: id,
        userId: userId,
        questionId: questionId,
        date: date,
        userResponse: userResponse,
        show: show);
  }

  ChatQuestion copyWith({
    String? id,
    String? userId,
    String? questionId,
    Timestamp? date,
    String? userResponse,
    bool? show,
  }) {
    return ChatQuestion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      questionId: questionId ?? this.questionId,
      date: date ?? this.date,
      userResponse: userResponse /*?? this.userResponse*/,
      show: show ?? this.show,
    );
  }
}
