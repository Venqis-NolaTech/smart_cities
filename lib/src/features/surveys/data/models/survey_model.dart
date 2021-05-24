import '../../../../core/util/list_util.dart';
import '../../domain/entities/survey.dart';
import '../../data/models/user_display_model.dart';

class SurveyListingsModel extends SurveyListings {
  SurveyListingsModel({
    int totalCount,
    List<SurveyModel> surveys,
  }) : super(
          totalCount: totalCount,
          surveys: surveys,
        );

  factory SurveyListingsModel.fromJson(Map<String, dynamic> json) {
    return SurveyListingsModel(
      totalCount: json['totalCount'],
      surveys: (json['polls'] as List).isNotNullOrNotEmpty
          ? List<SurveyModel>.from(
              json['polls'].map((v) => SurveyModel.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'polls': surveys.isNotNullOrNotEmpty
          ? surveys.map((r) => SurveyModel.fromEntity(r).toJson()).toList()
          : null,
    };
  }
}

class SurveyModel extends Survey {
  SurveyModel({
    String id,
    String name,
    String description,
    String channel,
    bool public,
    int votesCount,
    String link,
    List<StepModel> steps,
    UserDisplayModel createdBy,
    //nuevos campos
    String expirationDate,
    bool isHideParticipantData,
    bool isOtherShare,
    bool isAnswerByUser
  }) : super(
          id: id,
          name: name,
          description: description,
          channel: channel,
          public: public,
          votesCount: votesCount,
          link: link,
          steps: steps,
          createdBy: createdBy,
          expirationDate: expirationDate,
          isHideParticipantData: isHideParticipantData,
          isOtherShare: isOtherShare,
          isAnswerByUser: isAnswerByUser
        );

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      channel: json['container'],
      public: json['isPublic'],
      votesCount: json['votesCount'],
      link: json['link'],
      steps: (json['steps'] as List).isNotNullOrNotEmpty
          ? List<StepModel>.from(
              json['steps'].map((v) => StepModel.fromJson(v)))
          : null,
      createdBy: json['createdBy'] != null
          ? UserDisplayModel.fromJson(json['createdBy'])
          : null,
      expirationDate: json['expirationDate'],
      isHideParticipantData: json['isHideParticipantData'],
      isOtherShare: json['isOtherShare'],
      isAnswerByUser: json['isAnswerByUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'container': channel,
      'isPublic': public,
      'votesCount': votesCount,
      'link': link,
      'steps': steps.isNotNullOrNotEmpty
          ? steps.map((r) => StepModel.fromEntity(r).toJson()).toList()
          : null,
      'createdBy': createdBy != null
          ? UserDisplayModel.fromEntity(createdBy).toJson()
          : null,

      'expirationDate': expirationDate,
      'isHideParticipantData': isHideParticipantData,
      'isOtherShare': isOtherShare,
      'isAnswerByUser': isAnswerByUser
    };
  }

  Map<String, dynamic> toPayload() {
    return {
      'name': name,
      'description': description,
      'container': channel,
      'isPublic': public,
      'steps': steps.isNotNullOrNotEmpty
          ? steps.map((r) => StepModel.fromEntity(r).toPayload()).toList()
          : null,
      'expirationDate': expirationDate,
      'isHideParticipantData': isHideParticipantData,
      'isOtherShare': isOtherShare
    };
  }

  factory SurveyModel.fromEntity(Survey survey) {
    return SurveyModel(
      id: survey.id,
      name: survey.name,
      description: survey.description,
      channel: survey.channel,
      public: survey.public,
      votesCount: survey.votesCount,
      link: survey.link,
      steps: survey.steps.isNotNullOrNotEmpty
          ? survey.steps.map((s) => StepModel.fromEntity(s)).toList()
          : null,
      createdBy: survey.createdBy,
      expirationDate: survey.expirationDate,
      isHideParticipantData: survey.isHideParticipantData,
      isOtherShare: survey.isOtherShare,
      isAnswerByUser: survey.isAnswerByUser
    );
  }
}

class StepModel extends Step {
  StepModel({
    String id,
    String label,
    List<QuestionModel> questions,
  }) : super(
          id: id,
          label: label,
          questions: questions,
        );

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      id: json['_id'],
      label: json['label'],
      questions: (json['questions'] as List).isNotNullOrNotEmpty
          ? List<QuestionModel>.from(
              json['questions'].map((v) => QuestionModel.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': label,
      'questions': questions.isNotNullOrNotEmpty
          ? questions.map((r) => QuestionModel.fromEntity(r).toJson()).toList()
          : null,
    };
  }

  Map<String, dynamic> toPayload() {
    return {
      'label': label,
      'questions': questions.isNotNullOrNotEmpty
          ? questions
              .map((r) => QuestionModel.fromEntity(r).toPayload())
              .toList()
          : null,
    };
  }

  factory StepModel.fromEntity(Step step) {
    return StepModel(
      id: step.id,
      label: step.label,
      questions: step.questions.isNotNullOrNotEmpty
          ? step.questions.map((q) => QuestionModel.fromEntity(q)).toList()
          : null,
    );
  }
}

class QuestionModel extends Question {
  QuestionModel({
    String id,
    String keyID,
    String question,
    bool mandatory,
    QuestionType type,
    List<AnswerModel> answers,
  }) : super(
          id: id,
          keyID: keyID,
          question: question,
          mandatory: mandatory,
          type: type,
          answers: answers,
        );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'],
      keyID: json['keyID'],
      question: json['question'],
      mandatory: json['isMandatory'],
      type: QuestionTypeExtension.find(json['type']),
      answers: (json['answers'] as List).isNotNullOrNotEmpty
          ? List<AnswerModel>.from(
              json['answers'].map((v) => AnswerModel.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'keyID': keyID,
      'question': question,
      'isMandatory': mandatory,
      'type': type.value,
      'answers': answers.isNotNullOrNotEmpty
          ? answers.map((r) => AnswerModel.fromEntity(r).toJson()).toList()
          : null,
    };
  }

  Map<String, dynamic> toPayload() {
    return {
      'type': type.value,
      'question': question,
      'isMandatory': mandatory,
      'answers': answers.isNotNullOrNotEmpty
          ? answers.map((r) => AnswerModel.fromEntity(r).toPayload()).toList()
          : null,
    };
  }

  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      keyID: question.keyID,
      question: question.question,
      mandatory: question.mandatory,
      type: question.type,
      answers: question.answers.isNotNullOrNotEmpty
          ? question.answers.map((a) => AnswerModel.fromEntity(a)).toList()
          : null,
    );
  }
}

class AnswerModel extends Answer {
  AnswerModel({
    String id,
    String keyID,
    String answer,
    bool open,
  }) : super(
          id: id,
          keyID: keyID,
          answer: answer,
          open: open,
        );

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['_id'],
      keyID: json['keyID'],
      answer: json['answer'],
      open: json['isOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'keyID': keyID,
      'answer': answer,
      'isOpen': open,
    };
  }

  Map<String, dynamic> toPayload() {
    return {
      'answer': answer,
      'isOpen': open,
    };
  }

  factory AnswerModel.fromEntity(Answer answer) {
    return AnswerModel(
      id: answer.id,
      keyID: answer.keyID,
      answer: answer.answer,
      open: answer.open,
    );
  }
}
