import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/survey.dart';
import '../providers/crud_survey_provider.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart' as di;

class CrudSurveyAnswer extends StatefulWidget {
  const CrudSurveyAnswer({
    Key key,
    @required this.question,
    @required this.answer,
    @required this.onDeleteAnswer,
  }) : super(key: key);

  final QuestionData question;
  final AnswerData answer;
  final Function(String) onDeleteAnswer;

  @override
  _CrudSurveyAnswerState createState() => _CrudSurveyAnswerState();
}

class _CrudSurveyAnswerState extends State<CrudSurveyAnswer> {
  final _validator = di.sl<Validator>();

  final _inputTextEditingController = TextEditingController();
  final _inputFocus = FocusNode();

  QuestionType _questionType;
  bool _isHaveOnlyAnswer;
  bool _isOpen;

  @override
  void initState() {
    super.initState();

    _initData();

    final question = widget.question;

    _isHaveOnlyAnswer = (question?.answers?.length ?? 0) == 1;
    _isOpen = widget.answer.open;

    final isLastAnswer = question?.answers?.lastWhere(
          (a) => !a.open,
          orElse: () => null,
        ) ==
        widget.answer;

    if (!_isOpen && !_isHaveOnlyAnswer && isLastAnswer) {
      _inputFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _inputTextEditingController.dispose();

    _inputFocus.dispose();

    super.dispose();
  }

  void _initData() {
    _inputTextEditingController.text = widget.answer?.answer;
  }

  @override
  Widget build(BuildContext context) {
    final row = List<Widget>();

    _questionType = widget.question.type;

    if (_questionType == QuestionType.open) {
      row.addAll([
        Expanded(
          child: TextFormField(
            enabled: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: S.of(context).openAnswer,
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
      ]);
    } else {
      switch (_questionType) {
        case QuestionType.multipleChoice:
          row.addAll([
            Icon(
              MdiIcons.checkboxBlankCircleOutline,
              color: Colors.grey,
            ),
            Spaces.horizontalSmall(),
          ]);
          break;
        case QuestionType.checkBox:
          row.addAll([
            Icon(
              MdiIcons.checkboxBlankOutline,
              color: Colors.grey,
            ),
            Spaces.horizontalSmall(),
          ]);
          break;
        default:
          break;
      }

      row.add(
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (!_isOpen && !_validator.isRequired(value)) {
                return S.of(context).requiredField;
              }
              return null;
            },
            onSaved: (value) => widget.answer.answer = value,
            controller: _inputTextEditingController,
            enabled: !_isOpen,
            focusNode: _inputFocus,
            decoration: InputDecoration(
              hintText:
                  _isOpen ? S.of(context).other : S.of(context).optionName,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
      );
    }

    if (!_isHaveOnlyAnswer) {
      row.add(
        IconButton(
          icon: Icon(MdiIcons.close),
          onPressed: () => widget.onDeleteAnswer(widget.answer.key),
        ),
      );
    }

    return Row(children: row);
  }
}
