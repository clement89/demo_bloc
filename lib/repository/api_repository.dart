import 'dart:async';

import 'package:dio/dio.dart';
import 'package:morphosis_flutter_demo/modal/api_response.dart';
import 'package:morphosis_flutter_demo/repository/api_client.dart';

class ApiRepository {
  final ApiClient apiClient = ApiClient(httpClient: Dio());

  Future<ApiResponse> getUsers() async {
    ApiResponse response = await apiClient.fetchUsers();

    return response;
  }
}
