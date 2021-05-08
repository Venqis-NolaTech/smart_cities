import 'package:flutter/material.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart' as di;
import '../../../../../shared/constant.dart';
import '../../../../../shared/spaces.dart';
import '../providers/crud_survey_provider.dart';
import 'crud_survey_step.dart';

class CrudSurveyForm extends StatelessWidget {
  CrudSurveyForm({
    Key key,
    @required this.provider,
    @required this.formKey,
  }) : super(key: key);

  final CrudSurveyProvider provider;
  final GlobalKey<FormState> formKey;

  final _validator = di.sl<Validator>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildTitleField(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildDescription(context),
          ),
          Spaces.verticalLarge(),
          _buildSteps(context),
        ],
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextFormField(
      autofocus: true,
      initialValue: provider.survey.name,
      validator: (value) {
        if (!_validator.isRequired(value)) {
          return S.of(context).requiredField;
        }
        return null;
      },
      onSaved: (value) => provider.survey.name = value,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: S.of(context).fromTitle,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      style: kBigTitleStyle,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return TextFormField(
      initialValue: provider.survey.description,
      decoration: InputDecoration(hintText: S.of(context).description),
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      minLines: 1,
      maxLines: 6,
      style: kNormalStyle,
      onSaved: (value) => provider.survey.description = value,
    );
  }

  Widget _buildSteps(BuildContext context) {
    final survey = provider.survey;
    final steps = provider.survey.steps;

    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];

        return CrudSurveyStep(
          key: Key(step.key),
          survey: survey,
          step: step,
          onDeleteStep: () => provider.removeStep(step),
          onAddQuestion: () => provider.addQuestionToStep(step.key),
          onDeleteQuestion: (questionKey) =>
              provider.removeQuestion(questionKey),
          onDeleteAnswer: (answerKey) => provider.removeAnswer(answerKey),
          onAddAnswer: (questionKey, open) =>
              provider.addAnswerToQuestion(questionKey, open: open),
          onQuestionTypeChanged: (step, question, type) =>
              provider.changeTypeOfQuestion(step, question, type),
        );
      },
      separatorBuilder: (context, _) => Spaces.verticalSmall(),
    );
  }
}
