import 'dart:convert';

import 'package:morphosis_flutter_demo/modal/api_response.dart';
import 'package:morphosis_flutter_demo/modal/user.dart';
import 'package:morphosis_flutter_demo/repository/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class UsersListBloc {
  final ApiRepository _movieRepository = ApiRepository();
  final BehaviorSubject<ApiResponse> _subject = BehaviorSubject<ApiResponse>();
  ApiResponse response;

  getUsers() async {
    print('getting users..');
    response = await _movieRepository.getUsers();
    _subject.sink.add(response);
  }

  List<User> get users {
    final List<User> allUsers = [];
    if (!response.isError) {
      List<dynamic> responseData = jsonDecode(response.data);
      responseData.forEach((singleUser) {
        allUsers.add(User.fromJson(singleUser));
      });
    }
    return allUsers;
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ApiResponse> get subject => _subject;
}

final usersBloc = UsersListBloc();
