import 'package:blink/Result.dart';

class Response {
  final String message;
  final Result result;
  final String code;

  Response({this.message, this.result, this.code});

  factory Response.fromJson(Map<String, dynamic> json) {
    return new Response(
      message: json['message'].toString(),
      result: Result(
        hash: json['result']['hash'].toString(),
        url: json['result']['url'].toString(),
        orgUrl: json['result']['orgUrl'].toString(),
      ),
      code: json['code'].toString(),
    );
  }
}
