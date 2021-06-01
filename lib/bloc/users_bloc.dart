import 'dart:convert';

import 'package:morphosis_flutter_demo/modal/api_response.dart';
import 'package:morphosis_flutter_demo/modal/user.dart';
import 'package:morphosis_flutter_demo/repository/api_repository.dart';
import 'package:morphosis_flutter_demo/storage/storage_maneger.dart';
import 'package:rxdart/rxdart.dart';

class UsersListBloc {
  final ApiRepository _movieRepository = ApiRepository();
  final StorageManager _storageManager = StorageManager();
  final BehaviorSubject<List<User>> _subject = BehaviorSubject<List<User>>();

  getUsers() {
    print('getting users..');
    getUsersFromStorage();
    getUsersFromApi();
  }

  getUsersFromApi() async {
    print('getting users from api..');
    ApiResponse response = await _movieRepository.getUsers();
    List<User> allUsers = [];
    if (!response.isError) {
      List<dynamic> responseData = jsonDecode(response.data);
      responseData.forEach((singleUser) {
        allUsers.add(User.fromJson(singleUser));
      });
    }
    _storageManager.addUsers(allUsers);
    _subject.sink.add(allUsers);
  }

  getUsersFromStorage() async {
    print('getting users from storage..');
    List<User> allUsers = await _storageManager.getAllUsers();
    _subject.sink.add(allUsers);
  }

  dispose() {
    _subject.close();
    _storageManager.close();
  }

  BehaviorSubject<List<User>> get subject => _subject;
}

final usersBloc = UsersListBloc();
