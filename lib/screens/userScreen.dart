import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:technical_interview/services/Api.dart';
import 'package:technical_interview/services/Api_user.dart';
import 'package:technical_interview/services/add_user.dart';
import 'package:technical_interview/widgets/my_Button.dart';
import 'package:technical_interview/widgets/my_TextField.dart';

class UserList extends StatefulWidget {
  final String user;

  UserList({this.user});
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Future<List<Datum>> userimage;

  UserModel user;

  String fName;
  String lName;
  String email;

  String idName;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String currentuser = FirebaseAuth.instance.currentUser.email.toString();

  int index;

  Future<List<UserModel>> usermodel;

  @override
  void initState() {
    userimage = ApiManager().fetchData();
    // idname = currentuser.substringBefore("@");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: size.height * 0.15),
          child: Column(
            children: [
              ListTile(
                title: Text(
                    "trimmed email : \n ${firebaseAuth.currentUser.email.replaceAll(new RegExp('@gmail.com'), '')}"),
              ),
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  });
                },
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Datum>>(
              future: userimage,
              builder: (context, snapshot) {
                print("Here ${snapshot.hasData}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        print(snapshot.data[i].firstName);
                        print(snapshot.data[1].email);
                        return SwipeActionCell(
                          key: ObjectKey(snapshot),
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                                title: "delete",
                                onTap: (CompletionHandler handler) async {
                                  snapshot.data.removeAt(i);

                                  setState(() {});
                                },
                                color: Colors.red),
                          ],
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: ListTile(
                              tileColor: Colors.grey.shade800,
                              leading: CircleAvatar(
                                maxRadius: size.width * 0.08,
                                backgroundImage:
                                    NetworkImage(snapshot.data[i].avatar),
                              ),
                              title: Text(snapshot.data[i].firstName),
                              subtitle: Text(snapshot.data[i].email),
                            ),
                          ),
                        );
                      });
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            FutureBuilder<List<UserModel>>(
              future: usermodel,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.all(5),
                          child: ListTile(
                            tileColor: Colors.grey.shade800,
                            title: Text(snapshot.data[i].id),
                            subtitle: Text(snapshot.data[i].job),
                            onTap: () {
                              setState(() {
                                index = i;
                              });
                            },
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Container();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: size.height * 0.05),
                    child: Column(
                      children: [
                        MyTextField(
                          text: "First name",
                          icon: Icons.person,
                          obsecuretext: false,
                          function: (value) {
                            fName = value;
                          },
                        ),
                        MyTextField(
                          text: "Last name",
                          icon: Icons.person,
                          obsecuretext: false,
                          function: (value) {
                            lName = value;
                          },
                        ),
                        MyTextField(
                          text: "Email",
                          icon: Icons.alternate_email,
                          obsecuretext: false,
                          function: (value) {
                            email = value;
                          },
                        ),
                        MyButton(
                          id: "Add user",
                          function: () async {
                            // usermodel[i] = await ApiManager().addData(email, fName);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }
}
