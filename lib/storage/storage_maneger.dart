import 'package:hive/hive.dart';
import 'package:morphosis_flutter_demo/modal/user.dart';

class StorageManager {
  final userBox = Hive.box('users');

  void addUser(User user) {
    userBox.add(user);
  }

  List<User> getAllUsers() {
    return userBox.values;
  }

  void close() {
    Hive.box('users').compact();
    Hive.close();
  }
}
