import 'package:enreda_empresas/app/models/multiChoiceResponse.dart';
import 'package:enreda_empresas/app/models/yesNoResponse.dart';
import 'package:enreda_empresas/app/values/strings.dart';

class Question {
  Question({
    required this.id,
    required this.text,
    required this.order,
    required this.tag,
    required this.type,
    this.optionsToSelect,
    this.hasMultipleNextQuestions,
    this.nextQuestionId,
    this.choices,
    this.choicesCollection,
    this.inputType,
    this.confirmResponse,
    this.negativeResponse,
    this.link,
    this.experienceField,
    this.isLastQuestion,
  });

  final String id;
  final String text;
  final int order;
  final String tag;
  final String type;
  final int? optionsToSelect;
  final bool? hasMultipleNextQuestions;
  final String? nextQuestionId;
  final List<MultiChoiceResponse>? choices;
  final String? choicesCollection;
  final String? inputType;
  final YesNoResponse? confirmResponse;
  final YesNoResponse? negativeResponse;
  final String? link;
  final String? experienceField;
  final bool? isLastQuestion;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'order': order,
      'tag': tag,
      'type': type,
      'optionsToSelect': optionsToSelect,
      'hasMultipleNextQuestions': hasMultipleNextQuestions,
      'nextQuestionId': nextQuestionId,
      'choices': choices,
      'choicesCollection': choicesCollection,
      'inputType': inputType,
      'confirmResponse': confirmResponse,
      'negativeResponse': negativeResponse,
      'link': link,
      'experienceField': experienceField,
      'isLastQuestion': isLastQuestion,
    };
  }

  factory Question.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = data['id'];
    final String text = data['text'];
    final int order = data['order'];
    final String tag = data['tag'];
    final String type = data['type'];
    int? optionsToSelect;
    final bool? hasMultipleNextQuestions = data['hasMultipleNextQuestions'];
    final String? nextQuestionId = data['nextQuestionId'];
    final List<MultiChoiceResponse> choices = [];
    final String? choicesCollection = data['choicesCollection'];
    final String? inputType = data['inputType'];
    YesNoResponse? confirmResponse;
    YesNoResponse? negativeResponse;
    final String? link = data['link'];
    final String? experienceField = data['experienceField'];
    final bool? isLastQuestion = data['isLastQuestion'];

    switch (type) {
      case StringConst.MULTICHOICE_QUESTION:
        if (hasMultipleNextQuestions ?? false) {
          final choicesArray = data['choices'];
          choicesArray.forEach((element) {
            choices.add(MultiChoiceResponse(
                element['choiceId']!, element['nextQuestionId']!));
          });
        }
        optionsToSelect = data['optionsToSelect'];

        break;

      case StringConst.YES_NO_QUESTION:
        confirmResponse = YesNoResponse(data['confirmResponse']['text'],
            data['confirmResponse']['nextQuestionId']);
        negativeResponse = YesNoResponse(data['negativeResponse']['text'],
            data['negativeResponse']['nextQuestionId']);
        break;
    }

    return Question(
      id: id,
      text: text,
      order: order,
      tag: tag,
      type: type,
      optionsToSelect: optionsToSelect,
      hasMultipleNextQuestions: hasMultipleNextQuestions,
      nextQuestionId: nextQuestionId,
      choices: choices,
      choicesCollection: choicesCollection,
      inputType: inputType,
      confirmResponse: confirmResponse,
      negativeResponse: negativeResponse,
      link: link,
      experienceField: experienceField,
      isLastQuestion: isLastQuestion,
    );
  }
}
