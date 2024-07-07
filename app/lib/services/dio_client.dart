import 'package:burrito/data/entities/positions_response.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://143.198.141.62:6969',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

Future<List<BurritoInfoInTime>> getInfoAcrossTime() async {
  final response = await dio.get('/get-position/100');
  final burritoInfo = response.data['positions'] as List<dynamic>;
  return burritoInfo.map((e) => BurritoInfoInTime.fromJson(e)).toList();
}
