import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:morphosis_flutter_demo/modal/api_response.dart';
import 'package:morphosis_flutter_demo/repository/api_client.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {
  // ignore: non_constant_identifier_names
  MockApiClient({Dio httpClient}) {
    ApiClient _real = ApiClient(httpClient: Dio());
    when(fetchUsers()).thenAnswer((_) async => await _real.fetchUsers());
  }
}

void main() async {
  Dio dio = MockClient();

  final mockApiClient = MockApiClient(httpClient: dio);

  group('fetch users', () {
    DioAdapter dioAdapter;

    setUpAll(() {
      dioAdapter = DioAdapter();
      dio = Dio()..httpClientAdapter = dioAdapter;
    });

    test('mocks the data', () async {
      final mockData = ApiResponse(false, '', '');

      when(mockApiClient.fetchUsers())
          .thenAnswer((_) async => Future.value(mockData));

      expect(await mockApiClient.fetchUsers(), isA<ApiResponse>());
    });
  });
}
