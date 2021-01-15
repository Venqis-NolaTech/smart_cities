import 'package:equatable/equatable.dart';

class ResponseModel<T> extends Equatable {
  final bool success;
  final String message;
  final int code;
  final T data;

  ResponseModel({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      code: json['status_code'],
      data: json['data'],
    );
  }

  @override
  List<Object> get props => [
        success,
        message,
        code,
        data,
      ];
}
