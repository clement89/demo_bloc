import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/bloc/tasks_bloc.dart';
import 'package:morphosis_flutter_demo/modal/task.dart';
import 'package:morphosis_flutter_demo/repository/firebase_manager.dart';
import 'package:morphosis_flutter_demo/ui/screens/task.dart';

class TasksPage extends StatefulWidget {
  TasksPage({@required this.title});

  final String title;

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  void addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    tasksBloc..getTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: () => addTask(context),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<Task>>(
      stream: tasksBloc.subject.stream,
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        print('snapShoot - $snapshot');
        if (snapshot.hasData) {
          return _buildTasksWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildTasksWidget(List<Task> data) {
    if (data.length == 0) {
      return Container();
    } else {
      List<Task> taskList = data;
      if (widget.title == 'Completed Tasks') {
        taskList = data.where((t) => t.isCompleted).toList();
      }
      return ListView.builder(
        itemCount: taskList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _Task(
            taskList[index],
          );
        },
      );
    }
  }
}

class _Task extends StatefulWidget {
  _Task(this.task);

  final Task task;

  @override
  __TaskState createState() => __TaskState();
}

class __TaskState extends State<_Task> {
  void _delete() async {
    //TODO implement delete to firestore
    if (widget.task.id != null) {
      await FirebaseManager.shared.deleteTask(task: widget.task);
      tasksBloc.removeTask(widget.task);
    } else {
      print("Task id id null..");
    }
  }

  void _toggleComplete() {
    //TODO implement toggle complete to firestore
    if (widget.task.id != '') {
      FirebaseManager.shared.updateTask(task: widget.task);
      setState(() {
        widget.task.toggleComplete();
      });
      print(widget.task.toJson());
    } else {
      print("Task id id null..");
    }
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(task: widget.task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          widget.task.isCompleted
              ? Icons.check_box
              : Icons.check_box_outline_blank,
        ),
        onPressed: _toggleComplete,
      ),
      title: Text(widget.task.title),
      subtitle: Text(widget.task.description),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
        ),
        onPressed: _delete,
      ),
      onTap: () => _view(context),
    );
  }
}
