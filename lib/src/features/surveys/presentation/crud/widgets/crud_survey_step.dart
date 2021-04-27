import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart' as di;
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/custom_expansion_title.dart';
import '../../../../../shared/constant.dart';
import '../../../domain/entities/survey.dart';
import '../providers/crud_survey_provider.dart';
import 'crud_survey_question.dart';

class CrudSurveyStep extends StatefulWidget {
  const CrudSurveyStep({
    Key key,
    @required this.survey,
    @required this.step,
    @required this.onAddQuestion,
    @required this.onAddAnswer,
    @required this.onDeleteQuestion,
    @required this.onDeleteAnswer,
    @required this.onDeleteStep,
    @required this.onQuestionTypeChanged,
  }) : super(key: key);

  final SurveyData survey;
  final StepData step;
  final Function onAddQuestion;
  final Function(String, bool) onAddAnswer;
  final Function(String) onDeleteQuestion;
  final Function(String) onDeleteAnswer;
  final Function onDeleteStep;
  final Function(StepData, QuestionData, QuestionType) onQuestionTypeChanged;

  @override
  _CrudSurveyStepState createState() => _CrudSurveyStepState();
}

class _CrudSurveyStepState extends State<CrudSurveyStep> {
  final _validator = di.sl<Validator>();

  final inputTextEditingController = TextEditingController();

  bool _expanded = true;
  bool _isHaveOnlyAnswer;

  @override
  void initState() {
    super.initState();

    _initData();

    _isHaveOnlyAnswer = (widget.survey?.steps?.length ?? 0) == 1;
  }

  @override
  void dispose() {
    inputTextEditingController.dispose();

    super.dispose();
  }

  void _initData() {
    inputTextEditingController.text = widget.step?.label;
  }

  void _onExpansionChanged(expanded) {
    setState(() {
      _expanded = expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: CustomHeaderExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: _onExpansionChanged,
        headerBackgroundColor: AppColors.backgroundLight,
        trailing: _buildTrailingExpansionTitle(),
        title: _buildStepNameTextField(),
        children: <Widget>[
          _buildQuestions(),
          _buildAddQuestionBottom(),
        ],
      ),
    );
  }

  Widget _buildTrailingExpansionTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(_expanded ? MdiIcons.chevronUp : MdiIcons.chevronDown),
        _isHaveOnlyAnswer ? Container() : _buildPopupMenuButton(),
      ],
    );
  }

  Widget _buildStepNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextFormField(
        validator: (value) {
          if (!_validator.isRequired(value)) {
            return S.of(context).requiredField;
          }
          return null;
        },
        onSaved: (value) => widget.step.label = value,
        controller: inputTextEditingController,
        decoration: InputDecoration(
          hintText: S.of(context).step,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: kTitleStyle,
      ),
    );
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton(
      icon: Icon(
        MdiIcons.dotsHorizontal,
        color: Colors.black,
      ),
      onSelected: (option) {
        if (option == 0) widget.onDeleteStep();
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<int>>[
          PopupMenuItem(
            value: 0,
            child: Text(S.of(context).delete),
          ),
        ];
      },
    );
  }

  Widget _buildQuestions() {
    final questions = widget.step.questions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final isFirst = index == 0;

          return CrudSurveyQuestion(
            key: Key(question.key),
            question: question,
            isFirst: isFirst,
            onAddQuestion: widget.onAddQuestion,
            onAddAnswer: (open) => widget.onAddAnswer(question.key, open),
            onDeleteQuestion: widget.onDeleteQuestion,
            onDeleteAnswer: widget.onDeleteAnswer,
            onQuestionTypeChanged: (type) =>
                widget.onQuestionTypeChanged(widget.step, question, type),
            onMandatoryChanged: (value) => setState(() {
              question.mandatory = value;
            }),
          );
        },
      ),
    );
  }

  Widget _buildAddQuestionBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Spacer(),
          FlatButton.icon(
            icon: Icon(MdiIcons.plus),
            label: Text('Add question'),
            onPressed: widget.onAddQuestion,
          ),
        ],
      ),
    );
  }
}
