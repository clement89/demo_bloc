import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/bloc/tasks_bloc.dart';
import 'package:morphosis_flutter_demo/modal/task.dart';
import 'package:morphosis_flutter_demo/repository/firebase_manager.dart';

class TaskPage extends StatelessWidget {
  TaskPage({this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    print('buildong----');

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'New Task' : 'Edit Task'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _TaskForm(task),
    );
  }
}

class _TaskForm extends StatefulWidget {
  _TaskForm(this.task);

  final Task task;
  @override
  __TaskFormState createState() => __TaskFormState(task);
}

class __TaskFormState extends State<_TaskForm> {
  static const double _padding = 16;

  __TaskFormState(this.task);

  Task task;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  bool isEditing = false;

  void init() {
    if (task == null) {
      task = Task.fromJson({});
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    } else {
      isEditing = true;
      _titleController = TextEditingController(text: task.title);
      _descriptionController = TextEditingController(text: task.description);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void _save(BuildContext context) {
    //TODO implement save to firestore

    // String errorMsg = '';
    // if (_titleController.text.isEmpty) {
    //   errorMsg = 'Please enter title!';
    // } else if (_descriptionController.text.isEmpty) {
    //   errorMsg = 'Please enter description!';
    // }
    // if (errorMsg.isNotEmpty) {
    //   _showMessage(context, errorMsg);
    //   return;
    // }

    task.title = 'Title'; //_titleController.text;
    task.description = 'Testing';
    _descriptionController.text;

    if (isEditing) {
      print('Editing');
      FirebaseManager.shared.updateTask(task: task);
    } else {
      print('Creating${task.toJson()}');

      Random random = new Random();
      int randomNumber = random.nextInt(100);
      task.id = randomNumber.toString();
      tasksBloc.addTask(task);
      FirebaseManager.shared.createTask(task: task);
    }
    Navigator.of(context).pop();
  }

  _showMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    print('buildong----');

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            SizedBox(height: _padding),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              minLines: 5,
              maxLines: 10,
            ),
            SizedBox(height: _padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completed ?'),
                CupertinoSwitch(
                  value: task.isCompleted,
                  onChanged: (_) {
                    setState(() {
                      task.toggleComplete();
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => _save(context),
              child: Container(
                width: double.infinity,
                child: Center(child: Text(task.isNew ? 'Create' : 'Update')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
