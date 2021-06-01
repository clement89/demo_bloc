import 'package:hive/hive.dart';
import 'package:morphosis_flutter_demo/modal/user.dart';

class StorageManager {
  var userBox;

  void addUsers(List<User> users) {
    users.forEach((element) async {
      await userBox.put(element.email, element);
    });
  }

  Future<List<User>> getAllUsers() async {
    userBox = await Hive.openBox<User>('users');
    return userBox.values.toList();
  }

  void close() {
    Hive.box('users').compact();
    Hive.close();
  }
}
