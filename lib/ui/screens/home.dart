import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/bloc/users_bloc.dart';
import 'package:morphosis_flutter_demo/modal/api_response.dart';
import 'package:morphosis_flutter_demo/modal/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchTextField = TextEditingController();

  @override
  void initState() {
    _searchTextField.text = "Search";
    super.initState();
    usersBloc..getUsers();
  }

  @override
  void dispose() {
    _searchTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* In this section we will be testing your skills with network and local storage. You need to fetch data from any open source api from the internet. 
             E.g: 
             https://any-api.com/
             https://rapidapi.com/collection/best-free-apis?utm_source=google&utm_medium=cpc&utm_campaign=Beta&utm_term=%2Bopen%20%2Bsource%20%2Bapi_b&gclid=Cj0KCQjw16KFBhCgARIsALB0g8IIV107-blDgIs0eJtYF48dAgHs1T6DzPsxoRmUHZ4yrn-kcAhQsX8aAit1EALw_wcB
             Implement setup for network. You are free to use package such as Dio, Choppper or Http can ve used as well.
             Upon fetching the data try to store thmm locally. You can use any local storeage. 
             Upon Search the data should be filtered locally and should update the UI.
            */

            CupertinoSearchTextField(
              controller: _searchTextField,
            ),
            // Text(
            //   "Call any api you like from open apis and show them in a list. ",
            //   textAlign: TextAlign.center,
            // ),
            _buildUsers(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsers() {
    return StreamBuilder<ApiResponse>(
      stream: usersBloc.subject.stream,
      builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
        print('snapShoot - $snapshot');
        if (snapshot.hasData) {
          if (snapshot.data.isError) {
            return _buildErrorWidget(snapshot.data.errorMessage);
          }
          return _buildHomeWidget(snapshot.data);
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
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
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

  Widget _buildHomeWidget(ApiResponse data) {
    List<User> users = usersBloc.users;
    print(users);
    if (users.length == 0) {
      return Container();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(users[i].name),
            subtitle: Text(users[i].email),
          );
        },
        itemCount: users.length,
      );
    }
  }
}
