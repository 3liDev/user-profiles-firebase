import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'DatabaseManager/database_manager.dart';
import 'Services/authentication_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthenticationService _auth = AuthenticationService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  List userProfilesList = [];

  String userID = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDatabaseList();
  }

  fetchUserInfo() async {
    //FirebaseUser getUser = await FirebaseAuth.instance.currentUser();

    User getUser = FirebaseAuth.instance.currentUser!;
    userID = getUser.uid;
  }

  fetchDatabaseList() async {
    dynamic resultant = await DatabaseManager().getUsersList();

    if (resultant == null) {
      // ignore: avoid_print
      print('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultant;
      });
    }
  }

  updateData(String name, String gender, int score, String userID) async {
    await DatabaseManager().updateUserList(name, gender, score, userID);
    fetchDatabaseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              onPressed: () {
                openDialogueBox(context);
              },
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              // color: Colors.deepPurple,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              onPressed: () async {
                await _auth.signOut().then((result) {
                  Navigator.of(context).pop(true);
                });
              },
              child: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              // color: Colors.deepPurple,
            )
          ],
        ),
        body: ListView.builder(
            itemCount: userProfilesList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(userProfilesList[index]['name']),
                  subtitle: Text(userProfilesList[index]['gender']),
                  leading: const CircleAvatar(
                    child: Image(
                      image: AssetImage('assets/Profile_Image.png'),
                    ),
                  ),
                  trailing: Text('${userProfilesList[index]['score']}'),
                ),
              );
            }));
  }

  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit User Details'),
            content: SizedBox(
              height: 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: _genderController,
                      decoration: const InputDecoration(hintText: 'Gender'),
                    ),
                    TextField(
                      controller: _scoreController,
                      decoration: const InputDecoration(hintText: 'Score'),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  submitAction(context);
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    updateData(_nameController.text, _genderController.text,
        int.parse(_scoreController.text), userID);
    _nameController.clear();
    _genderController.clear();
    _scoreController.clear();
  }
}
