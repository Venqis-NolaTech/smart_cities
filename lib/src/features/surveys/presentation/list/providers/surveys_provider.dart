import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/get_all_surveys_use_case.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../shared/provider/paginated_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../auth/domain/usecases/logged_user_use_case.dart';
import '../../../domain/entities/survey.dart';
import '../../../domain/usecases/delete_survey_use_case.dart';
import '../../../domain/usecases/disable_survey_use_case.dart';
import '../../../domain/usecases/publish_survey_use_case.dart';

class SurveysProvider extends PaginatedProvider<Survey> {
  SurveysProvider({
    @required LoggedUserUseCase loggedUserUseCase,
    @required this.getAllSurveysByChannelUseCase,
    @required this.publishSurveyUseCase,
    @required this.disableSurveyUseCase,
    @required this.deleteSurveyUseCase,
  }) : super(loggedUserUseCase: loggedUserUseCase);

  final GetAllSurveysUseCase getAllSurveysByChannelUseCase;
  final PublishSurveyUseCase publishSurveyUseCase;
  final DisableSurveyUseCase disableSurveyUseCase;
  final DeleteSurveyUseCase deleteSurveyUseCase;

  ViewState _optionSurveyState = Idle();
  ViewState get optionSurveyState => _optionSurveyState;

  void _setOptionSurveyState(ViewState state) {
    _optionSurveyState = state;

    notifyListeners();
  }


  void loadData() async {
    await super.getUser(notify: false);

    super.fetchData();
  }

  void publish(Survey survey) async {
    _setOptionSurveyState(Loading());

    final failureOrSucess = await publishSurveyUseCase(survey.id);

    failureOrSucess.fold(
      (_) {},
      (surveyPublished) {
        final index = items.indexOf(survey);

        items.replaceRange(index, index + 1, [surveyPublished]);

        controller.sink.add(items);
      },
    );

    _setOptionSurveyState(Loaded());
  }

  Future disable(Survey survey) async {
    _setOptionSurveyState(Loading());

    final failureOrSucess = await disableSurveyUseCase(survey.id);

    failureOrSucess.fold(
      (failure) => _setOptionSurveyState(Error(failure: failure)),
      (surveyDisabled) {
        final index = items.indexOf(survey);

        items.replaceRange(index, index + 1, [surveyDisabled]);

        controller.sink.add(items);

        _setOptionSurveyState(Loaded());
      },
    );
  }

  Future delete(Survey survey) async {
    _setOptionSurveyState(Loading());

    final failureOrSucess = await deleteSurveyUseCase(survey.id);

    failureOrSucess.fold(
      (failure) => _setOptionSurveyState(Error(failure: failure)),
      (deleted) {
        if (deleted) {
          items.remove(survey);
          controller.sink.add(items);
        }

        _setOptionSurveyState(Loaded());
      },
    );
  }

  @override
  Future<Either<Failure, PageData<Survey>>> processRequest() async {
    final params = AllSurveysParams(
      page: page,
      count: count,
    );

    final failureOrListings = await getAllSurveysByChannelUseCase(params);

    return failureOrListings.fold((failure) => Left(failure), (listings) {
      final surveys = listings?.surveys ?? [];

      return Right(
        PageData(
          totalCount: listings.totalCount,
          items: surveys,
        ),
      );
    });
  }
}
