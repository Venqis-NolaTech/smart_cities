import 'package:equatable/equatable.dart';
import 'user_display.dart';



enum QuestionType {
  open,
  multipleChoice,
  checkBox,
  dropDownList,
}

extension QuestionTypeExtension on QuestionType {
  String get value => this.toString().split('.').last;

  static QuestionType find(String value) => QuestionType.values
      .firstWhere((v) => v.value == value, orElse: () => null);
}

class SurveyListings extends Equatable {
  final int totalCount;
  final List<Survey> surveys;

  SurveyListings({this.totalCount, this.surveys});

  @override
  List<Object> get props => [totalCount, surveys];
}

class Survey extends Equatable {
  final String id;
  final String name;
  final String description;
  final String channel;
  final bool public;
  final int votesCount;
  final List<Step> steps;
  final UserDisplay createdBy;
  final String link;

  Survey({
    this.id,
    this.name,
    this.description,
    this.channel,
    this.public,
    this.votesCount,
    this.steps,
    this.createdBy,
    this.link,
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
        channel,
        public,
        votesCount,
        link,
        steps,
        createdBy,
      ];
}

class Step extends Equatable {
  final String id;
  final String label;
  final List<Question> questions;

  Step({
    this.id,
    this.label,
    this.questions,
  });

  @override
  List<Object> get props => [
        id,
        label,
        questions,
      ];
}

class Question extends Equatable {
  final String id;
  final String keyID;
  final String question;
  final bool mandatory;
  final QuestionType type;
  final List<Answer> answers;

  Question({
    this.id,
    this.keyID,
    this.question,
    this.mandatory,
    this.type,
    this.answers,
  });

  @override
  List<Object> get props => [
        id,
        keyID,
        question,
        mandatory,
        type,
        answers,
      ];
}

class Answer extends Equatable {
  final String id;
  final String keyID;
  final String answer;
  final bool open;

  Answer({
    this.id,
    this.keyID,
    this.answer,
    this.open,
  });

  @override
  List<Object> get props => [
        id,
        keyID,
        answer,
        open,
      ];
}
