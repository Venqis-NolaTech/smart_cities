import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/places/domain/usescase/new_review_place_use_case.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/providers/base_new_report_form_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../../shared/provider/base_provider.dart';

class NewReviewProvider extends BaseProvider{

    final NewReviewPlaceUseCase newReviewPlaceUseCase;
    NewReviewProvider({@required this.newReviewPlaceUseCase});
    

    String title;
    String comment;
    double qualification=5;

    String placeId;


  Future submitData(String id) async {
    placeId= id;
    final payload = {
      DataKey.RANTING : qualification,
      DataKey.COMMENT: comment,
      DataKey.TITLE: ''
    };

    await _createComment(payload);
  }

  Future _createComment(Map<String, dynamic> request) async {
    if (request != null && request.isEmpty) return;

    state = Loading();

    final params= NewReviewParams(placeId: placeId, request: request);
    final failureOrSuccess = await newReviewPlaceUseCase(params);

    await failureOrSuccess.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (comment) async {
        if (comment != null) {
           state = Loaded(value: comment);
        } else {
          state = Error(failure: UnexpectedFailure());
        }
      },
    );


  }

  bool validate() {
    if(comment==null || qualification==null)
      return false;
    else 
      return true;
  }



}