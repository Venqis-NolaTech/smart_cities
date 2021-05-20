import 'package:smart_cities/src/features/payments/presentation/detail_account/page/detail_account_page.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/get_detail_survey_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/util/list_util.dart';
import '../../../../../core/util/object_id.dart';
import '../../../../../core/util/string_util.dart';
import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/survey.dart';
import '../../../domain/usecases/create_survey_use_case.dart';
import '../../../domain/usecases/edit_survey_use_case.dart';

class CrudSurveyProvider extends BaseProvider {
  CrudSurveyProvider({
    @required this.createSurveyUseCase,
    @required this.editSurveyUseCase,
    @required this.detailsSurveyUseCase,
  });

  final CreateSurveyUseCase createSurveyUseCase;
  final EditSurveyUseCase editSurveyUseCase;
  final DetailsSurveyUseCase detailsSurveyUseCase;

  SurveyData _survey;
  SurveyData get survey => _survey;

  void initSurvey({Survey survey}) async  {
    if (survey != null) {
      //obtener datos complementarios de la encuesta

      state = Loading();
      _survey = SurveyData.fromEntity(survey);

      Either<Failure, Survey> failureOrSuccess= await detailsSurveyUseCase(DetailsSurveyParams(surveyId: _survey.id));
    
      failureOrSuccess.fold(
        (failure) => state = Error(failure: failure),
        (surveyP) {
          _survey = SurveyData.fromEntity(surveyP);
          state = Loaded<Survey>(value: surveyP);
        }
      );



    } else {
      var dayExp = DateTime.now().add(Duration(hours: 6));
      _survey = SurveyData(
          key: ObjectId().toHexString(),
          name: "",
          description: "",
          public: true,
          steps: List<StepData>(),
          expirationDate: dayExp.toString(),
          isOtherShare: true,
          isHideParticipantData: false);

      addStep();
    }
  }

  Future save() async {
    state = Loading();

    final survey = _survey.toEntity();

    Either<Failure, Survey> failureOrSuccess;

    if (survey.id.isNotNullOrNotEmpty) {
      failureOrSuccess = await _edit(survey);
    } else {
      failureOrSuccess = await _save(survey);
    }

    failureOrSuccess.fold(
      (failure) => state = Error(failure: failure),
      (survey) => state = Loaded<Survey>(value: survey),
    );
  }

  void addStep() {
    final stepKey = ObjectId().toHexString();
    final step = StepData(
      key: stepKey,
      label: "",
      questions: [_createQuestion(stepKey)],
    );

    _survey.steps.add(step);

    notifyListeners();
  }

  void removeStep(StepData step) {
    if (_survey.steps.remove(step)) notifyListeners();
  }

  void addQuestionToStep(String stepKey) {
    final step = _getStep(stepKey);

    if (step == null) return;

    step.questions.add(_createQuestion(stepKey));

    notifyListeners();
  }

  void removeQuestion(String questionKey) {
    final step = _getStepByQuestionKey(questionKey);

    if (step == null) return;

    step.questions.removeWhere((question) => question.key == questionKey);

    notifyListeners();
  }

  void addAnswerToQuestion(String questionKey, {bool open = false}) {
    final step = _getStepByQuestionKey(questionKey);

    if (step == null) return;

    final question = _getQuestion(step, questionKey);

    if (question == null) return;

    question.answers.add(_createAnswer(questionKey, open: open));

    notifyListeners();
  }

  void removeAnswer(String answerKey) {
    final question = _getQuestionByAnswerKey(answerKey);

    if (question == null) return;

    question.answers.removeWhere((answer) => answer.key == answerKey);

    notifyListeners();
  }

  void changeTypeOfQuestion(
    StepData step,
    QuestionData question,
    QuestionType type,
  ) {
    final index = step.questions.indexOf(question);

    if (type == QuestionType.open) {
      question.answers = [_createAnswer(question.key)];
    } else if (type == QuestionType.dropDownList) {
      question.answers.removeWhere((a) => a.open);
    }

    question.type = type;
    step.questions[index] = question;

    notifyListeners();
  }

  // private methods --
  Future<Either<Failure, Survey>> _save(Survey survey) {
    print('nueva encuesta ${survey.expirationDate}');
    print('nueva encuesta ${survey.isOtherShare}');
    print('nueva encuesta ${survey.isHideParticipantData}');
    return createSurveyUseCase(survey);
  }

  Future<Either<Failure, Survey>> _edit(Survey survey) {
    final params = EditSurveyParams(
      surveyId: survey.id,
      survey: survey,
    );

    return editSurveyUseCase(params);
  }

  StepData _getStep(String key) =>
      _survey.steps.firstWhere((step) => step.key == key, orElse: () => null);

  StepData _getStepByQuestionKey(String key) {
    final stepKey = key.split('-').first;

    if (stepKey == null) return null;

    return _getStep(stepKey);
  }

  QuestionData _getQuestion(StepData step, String key) => step.questions
      .firstWhere((question) => question.key == key, orElse: () => null);

  QuestionData _getQuestionByAnswerKey(String key) {
    final keys = key.split('-');

    final stepKey = keys[0];
    final questionKey = keys[1];

    if (stepKey == null || questionKey == null) return null;

    final step = _getStep(stepKey);

    if (stepKey == null) return null;

    return _getQuestion(step, '$stepKey-$questionKey');
  }

  QuestionData _createQuestion(String stepKey) {
    final questionKey = '$stepKey-${ObjectId().toHexString()}';
    return QuestionData(
      key: questionKey,
      type: QuestionType.multipleChoice,
      question: "",
      mandatory: false,
      answers: [_createAnswer(questionKey)],
    );
  }

  AnswerData _createAnswer(String questionKey, {open = false}) {
    return AnswerData(
      key: '$questionKey-${ObjectId().toHexString()}',
      open: open,
      answer: open ? null : "",
    );
  }
  // -- private methods
}

// data transfers objects
class SurveyData {
  String id;
  String key;
  String name;
  String description;
  bool public;
  final List<StepData> steps;

  //nuevos campos
  String expirationDate;
  bool isHideParticipantData;
  bool isOtherShare;

  SurveyData(
      {this.id,
      this.key,
      this.name,
      this.description,
      this.public,
      this.steps,
      this.expirationDate,
      this.isOtherShare,
      this.isHideParticipantData});

  factory SurveyData.fromEntity(Survey survey) {
    return SurveyData(
        id: survey.id,
        key: survey.id,
        name: survey.name,
        description: survey.description,
        public: survey.public,
        steps: survey.steps.isNotNullOrNotEmpty
            ? survey.steps.map((s) => StepData.fromEntity(s)).toList()
            : [],
        expirationDate: survey.expirationDate,
        isHideParticipantData: survey.isHideParticipantData,
        isOtherShare: survey.isOtherShare);
  }

  Survey toEntity() {
    return Survey(
        id: this.id,
        name: this.name,
        description: this.description,
        public: this.public,
        steps: this.steps.isNotNullOrNotEmpty
            ? this.steps.map((s) => s.toEntity()).toList()
            : [],
        expirationDate: this.expirationDate,
        isHideParticipantData: this.isHideParticipantData,
        isOtherShare: this.isOtherShare);
  }
}

class StepData {
  String key;
  String label;
  List<QuestionData> questions;

  StepData({this.key, this.label, this.questions});

  factory StepData.fromEntity(Step step) {
    final questionKey = "${step.id}-${ObjectId().toHexString()}";

    return StepData(
      key: step.id,
      label: step.label,
      questions: step.questions.isNotNullOrNotEmpty
          ? step.questions.map((q) => QuestionData.fromEntity(q)).toList()
          : [
              QuestionData(
                key: questionKey,
                type: QuestionType.multipleChoice,
                question: "",
                mandatory: false,
                answers: [
                  AnswerData(
                    key: '$questionKey-${ObjectId().toHexString()}',
                    open: false,
                    answer: "",
                  )
                ],
              )
            ],
    );
  }

  Step toEntity() {
    return Step(
        label: this.label,
        questions: this.questions.isNotNullOrNotEmpty
            ? this.questions.map((q) => q.toEntity()).toList()
            : []);
  }
}

class QuestionData {
  String id;
  String key;
  QuestionType type;
  String question;
  bool mandatory;
  List<AnswerData> answers;

  QuestionData({
    this.id,
    this.key,
    this.type,
    this.question,
    this.mandatory,
    this.answers,
  });

  factory QuestionData.fromEntity(Question question) {
    return QuestionData(
      id: question.id,
      key: question.keyID,
      type: question.type,
      question: question.question,
      mandatory: question.mandatory,
      answers: question.answers.isNotNullOrNotEmpty
          ? question.answers.map((a) => AnswerData.formEntity(a)).toList()
          : [
              AnswerData(
                key: '${question.keyID}-${ObjectId().toHexString()}',
                open: false,
                answer: "",
              )
            ],
    );
  }

  Question toEntity() {
    return Question(
        type: this.type,
        question: this.question,
        mandatory: this.mandatory,
        answers: this.answers.isNotNullOrNotEmpty
            ? this.answers.map((a) => a.toEntity()).toList()
            : []);
  }

  bool get isHaveOtherAnswer =>
      answers.firstWhere((a) => a.open == true, orElse: () => null) != null;
}

class AnswerData {
  String id;
  String key;
  bool open;
  String answer;

  AnswerData({this.id, this.key, this.open, this.answer});

  factory AnswerData.formEntity(Answer answer) {
    return AnswerData(
      id: answer.id,
      key: answer.keyID,
      open: answer.open,
      answer: answer.answer,
    );
  }

  Answer toEntity() {
    return Answer(
      open: this.open,
      answer: this.answer,
    );
  }
}
