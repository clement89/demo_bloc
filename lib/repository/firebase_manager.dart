import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:morphosis_flutter_demo/modal/task.dart';

class FirebaseManager {
  static FirebaseManager _one;

  static FirebaseManager get shared =>
      (_one == null ? (_one = FirebaseManager._()) : _one);
  FirebaseManager._();

  Future<void> initialise() => Firebase.initializeApp();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  //TODO: change collection name to something unique or your name
  CollectionReference get tasksRef =>
      FirebaseFirestore.instance.collection('tasks');

  //TODO: replace mock data. Remember to set the task id to the firebase object id
  List<Task> get tasks => mockData.map((t) => Task.fromJson(t)).toList();

  //TODO: implement firestore CRUD functions here

  Future<void> createTask({Task task}) async {
    return tasksRef
        .doc(task.id)
        .set(task.toJson())
        .then((value) => print("Task Added"))
        .catchError((error) => print("Failed to add Task: $error"));
  }

  Future<void> updateTask({Task task}) async {
    try {
      tasksRef
          .doc(task.id)
          .update(task.toJson())
          .then((value) => print("Task Updated"))
          .catchError((error) => print("Failed to update task: $error"));
    } on SocketException {
      print('No internet connection');
    }
  }

  Future readAllTasks() async {
    try {
      List<Task> taskList = [];
      await tasksRef.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print('doc - ${doc.data()}');
          Task task = Task.fromJson(doc.data());
          task.id = doc.id;

          taskList.add(task);
        });
      });
      return taskList;
    } on SocketException {
      print('No internet connection');
    }
  }

  Future readCompletedTasks() async {
    try {
      List<Task> taskList = [];
      await tasksRef
          .where('completed_at', isNotEqualTo: null)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print('doc - ${doc.data()}');

          Task task = Task.fromJson(doc.data());
          task.id = doc.id;
          taskList.add(task);
        });
      });
      return taskList;
    } on SocketException {
      print('No internet connection');
    }
  }

  Future<void> deleteTask({Task task}) async {
    return await tasksRef
        .doc(task.id)
        .delete()
        .then((value) => print("Task Deleted"))
        .catchError((error) => print("Failed to delete task: $error"));
  }
}

List<Map<String, dynamic>> mockData = [
  {"id": "1", "title": "Task 1", "description": "Task 1 description"},
  {
    "id": "2",
    "title": "Task 2",
    "description": "Task 2 description",
    "completed_at": DateTime.now().toIso8601String()
  }
];
