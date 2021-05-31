import 'package:morphosis_flutter_demo/modal/task.dart';
import 'package:morphosis_flutter_demo/repository/firebase_manager.dart';
import 'package:rxdart/rxdart.dart';

class TasksListBloc {
  final BehaviorSubject<List<Task>> _tasks = BehaviorSubject<List<Task>>();

  List<Task> taskList = [];

  getTasks() async {
    print('getting Tasks..');
    taskList = await FirebaseManager.shared.readAllTasks();
    _tasks.sink.add(taskList);
  }

  void addTask(Task task) {
    taskList.add(task);
    _tasks.sink.add(taskList);
  }

  void removeTask(Task task) {
    taskList.remove(task);
    _tasks.sink.add(taskList);
  }

  dispose() {
    _tasks.close();
  }

  BehaviorSubject<List<Task>> get subject => _tasks;
}

final tasksBloc = TasksListBloc();
