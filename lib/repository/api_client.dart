import 'package:dio/dio.dart';
import 'package:morphosis_flutter_demo/modal/api_response.dart';

class ApiClient {
  //Define base url
  final String _baseUrl =
      'https://db94e50b-0f92-4b9f-9011-8e45b95dd6ae.mock.pstmn.io/api';

  final Dio httpClient;

  ApiClient({this.httpClient}) : assert(httpClient != null);

  Future<ApiResponse> fetchUsers() async {
    final url = '$_baseUrl/users/';
    try {
      Response response = await httpClient.get(url);
      return ApiResponse(false, '', response.data.toString());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ApiResponse(true, error, '');
    }
  }
}
