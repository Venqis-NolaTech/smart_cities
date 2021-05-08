import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart' as di;
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/platform_switch_tilte.dart';
import '../../../../../shared/constant.dart';
import '../../../domain/entities/survey.dart';
import '../providers/crud_survey_provider.dart';
import 'crud_survey_answer.dart';

class CrudSurveyQuestion extends StatefulWidget {
  const CrudSurveyQuestion({
    Key key,
    @required this.question,
    @required this.onAddQuestion,
    @required this.onAddAnswer,
    @required this.onDeleteQuestion,
    @required this.onDeleteAnswer,
    @required this.onQuestionTypeChanged,
    @required this.onMandatoryChanged,
    this.isFirst = false,
  }) : super(key: key);

  final QuestionData question;
  final Function onAddQuestion;
  final Function(bool) onAddAnswer;
  final Function(String) onDeleteQuestion;
  final Function(String) onDeleteAnswer;
  final Function(QuestionType) onQuestionTypeChanged;
  final Function(bool) onMandatoryChanged;
  final bool isFirst;

  @override
  _CrudSurveyQuestionState createState() => _CrudSurveyQuestionState();
}

class _CrudSurveyQuestionState extends State<CrudSurveyQuestion> {
  final _validator = di.sl<Validator>();

  final _inputTextEditingController = TextEditingController();
  final _inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _initData();

    if (!widget.isFirst) _inputFocus.requestFocus();
  }

  @override
  void dispose() {
    _inputTextEditingController.dispose();

    _inputFocus.dispose();

    super.dispose();
  }

  void _initData() {
    _inputTextEditingController.text = widget.question?.question;
  }

  void _addAnswer(bool open) {
    widget.onAddAnswer(open);

    _inputFocus.unfocus();
  }

  void _onMandatoryChanged(value) {
    widget.onMandatoryChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final isOpenQuestion = widget.question.type == QuestionType.open;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (!_validator.isRequired(value)) {
                  return S.of(context).requiredField;
                }
                return null;
              },
              onSaved: (value) => widget.question.question = value,
              decoration: InputDecoration(hintText: S.of(context).question),
              controller: _inputTextEditingController,
              focusNode: _inputFocus,
              style: kNormalStyle,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
            ),
            _buildQuestionTypeDropDown(),
          ],
        ),
        _buildAnswers(context),
        !isOpenQuestion ? _buildAddAnswerBottom() : Container(),
        _buildQuestionToolsBottom(),
      ],
    );
  }

  Widget _buildQuestionTypeDropDown() {
    final option = {
      QuestionType.open: S.of(context).textField,
      QuestionType.multipleChoice: S.of(context).miltipleChoice,
      QuestionType.checkBox: S.of(context).checkbox,
      QuestionType.dropDownList: S.of(context).dropDownList,
    };

    return DropdownButton<QuestionType>(
      value: widget.question.type,
      items: option.entries
          .map(
            (iterate) => DropdownMenuItem<QuestionType>(
              value: iterate.key,
              child: Text(iterate.value),
            ),
          )
          .toList(),
      onChanged: widget.onQuestionTypeChanged,
    );
  }

  Widget _buildAnswers(BuildContext context) {
    final question = widget.question;
    final answers = widget.question.answers;
    answers.sort((a, b) => a.open == b.open ? 0 : a.open ? 1 : -1);

    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: answers.length,
      itemBuilder: (context, index) {
        final answer = answers[index];

        return CrudSurveyAnswer(
          key: Key(answer.key),
          question: question,
          answer: answer,
          onDeleteAnswer: widget.onDeleteAnswer,
        );
      },
    );
  }

  Widget _buildAddAnswerBottom() {
    final question = widget.question;

    final isDropdownType = question.type == QuestionType.dropDownList;
    final isHaveOtherOption = question.isHaveOtherAnswer;

    final addOptionButton = FlatButton(
      child: Text(
        S.of(context).addOption,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () => _addAnswer(false),
    );

    final orText = Text(
      S.of(context).or,
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );

    final addOtherOptionButton = FlatButton(
      child: Text(
        S.of(context).addOther,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.blue,
        ),
      ),
      onPressed: () => _addAnswer(true),
    );

    if (isHaveOtherOption || isDropdownType) {
      return Row(
        children: <Widget>[
          addOptionButton,
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          addOptionButton,
          orText,
          addOtherOptionButton,
        ],
      );
    }
  }

  Widget _buildQuestionToolsBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(MdiIcons.deleteOutline),
          onPressed: () => widget.onDeleteQuestion(widget.question.key),
        ),
        Flexible(
          child: PlatformSwitchListTile(
            value: widget.question.mandatory,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              S.of(context).mandatory,
              style: kSmallestTextStyle,
            ),
            onChanged: _onMandatoryChanged,
          ),
        ),
      ],
    );
  }
}
