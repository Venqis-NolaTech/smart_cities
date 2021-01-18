import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ValuesFiltresKey{
  static const MY_REPORTS = 'my_reports';
  static const IN_PROCESS = 'in_process';
  static const SOLUTION_COMPLETED = 'solution_completed';
  static const NOT_ATTEND = 'not_attend';
  static const AREA_PEDESTRIAN = 'area_peatonal';
  static const AREA_RECREATIONAL = 'area_recreational';
  static const AREA_GREEN = 'area_green';

}
abstract class ReportFilterDataSource{
  bool getValue(String key);
  Future<bool> setValue(String key, bool value);
  Future<bool> clear();
}


class ReportFilterDataSourceImpl implements ReportFilterDataSource{

  ReportFilterDataSourceImpl({
    @required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;



  @override
  Future<bool> clear() {
    return sharedPreferences.clear();
  }

  @override
  bool getValue(String key) {
    return sharedPreferences.getBool(key);
  }

  @override
  Future<bool> setValue(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

}