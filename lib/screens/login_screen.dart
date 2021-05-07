import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:technical_interview/widgets/my_Button.dart';
import 'package:technical_interview/widgets/my_TextField.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextField(
            text: "Email",
            icon: Icons.alternate_email_outlined,
            obsecuretext: false,
            function: (value) {
              email = value;
            },
          ),
          MyTextField(
            text: 'password',
            icon: Icons.vpn_key_rounded,
            obsecuretext: false,
            function: (value) {
              password = value;
            },
          ),
          MyButton(
            id: "Login",
            function: () async {
              if (email == 'admin@gmail.com' && password == 'admin@123') {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                Navigator.of(context)
                    .popAndPushNamed('/user', arguments: [email.toString()]);
              } else if (email != 'admin@gmail.com') {
                Toast.show("Invalid Email", context,
                    duration: Toast.LENGTH_LONG);
              } else if (password != "admin@123") {
                Toast.show("Invalid Email", context,
                    duration: Toast.LENGTH_LONG);
              }
            },
          )
        ],
      ),
    );
  }
}
