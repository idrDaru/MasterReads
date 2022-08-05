import 'dart:math';


import 'package:flutter/material.dart';
import 'package:masterreads/Service/authentication.dart';
import 'package:masterreads/Service/dashboardManager.dart';
import 'package:masterreads/models/users.dart';
import 'package:provider/provider.dart';


class UserModel extends StatefulWidget {
  const UserModel({Key? key}) : super(key: key);

  @override
  State<UserModel> createState() => UserModelState();

}

class UserModelState extends State<UserModel> {
  // List<eUserModel> userModels = <eUserModel>[];
  List userModels=[];

  @override
  void initState() {
    userGet().then((data) {
      setState(() {

      });
    });
    super.initState();
  }

  Future<void> userGet() async {

    userModels = await Manager().getUsersList();


  }

  @override
  Widget build(BuildContext context) {


    var app = Scaffold(

      appBar: AppBar(
        title: Text(
          'Users',
          style: TextStyle(color: Colors.purple),
        ),
        iconTheme: IconThemeData(color: Colors.purple),
        backgroundColor: Colors.white,
      ),
      // drawer: MyDrawer(),
      body: getUserList(),
    );
    return app;
  }

  ListView getUserList() {
    var app = ListView.builder(
        itemCount: userModels.length == null ? 0 : userModels.length,
        itemBuilder: (BuildContext context, int index) {


          return Card(

            child: ListTile(
              title: Text(userModels[index]['firstName']+ '\t'+
                (userModels[index]['secondName']),),
              subtitle: Text(userModels[index]['role']),

          leading: CircleAvatar(
                  backgroundColor: Colors.accents[Random().nextInt(Colors.accents.length)] ,
                  radius: 30.0,
                  // child: Icon(Icons.person)
                  child: Text(_getTitle(userModels[index]['firstName'])+ _getTitle(userModels[index]['secondName']))),

                trailing: Container(
          width: 100,
          child: ElevatedButton(onPressed: () {  },
            style: ElevatedButton.styleFrom(
              primary:Colors.grey[500],

            ),
          child: Text("blacklist"
          ),
          
          ),
            ),

            ),

          );
        });
    return app;
  }

  String _getTitle(String firstName) {
    return firstName.substring(0, 1);
  }
}
