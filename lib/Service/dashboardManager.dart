import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masterreads/views/Admin/ListUsers.dart';
class Manager{
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  String role='', uid='', email='', firstname='', secondname='';
  Future getUsersList() async {
    List itemsList = [];
    // List<UserModel> itemList = [];
    // UserModel euser=UserModel(role, uid, email, firstname, secondname );

    try {

      await users.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          // print(element.data());

          print(element.reference);
          itemsList.add(element.data());

          print(itemsList[0]);

        });
      });

      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}