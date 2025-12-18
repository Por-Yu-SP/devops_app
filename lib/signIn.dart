// ignore_for_file: file_names, use_build_context_synchronously

import 'package:devops_app/homepage.dart';
import 'package:devops_app/info.dart';
import 'package:flutter/material.dart';
import 'service.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController admcontrol = TextEditingController();
  final TextEditingController passwordcontrol = TextEditingController();
  final SnackBar wrongpass = SnackBar(
    content: Text("Incorrect Details"),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.red,
  );
  void checkCreds() async {
    if (services.verifypass(admcontrol.text, passwordcontrol.text)) {
      await services.getAllbook();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(wrongpass);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Welcome to NLB",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: TextField(
                  controller: admcontrol,
                  decoration: InputDecoration(
                    labelText: "Enter Admin Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: TextField(
                  controller: passwordcontrol,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 50),
            SizedBox(
              height: 45,
              width: 150,
              child: FilledButton(
                onPressed: () {
                  checkCreds();
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                child: Text("Login", style: TextStyle(fontSize: 25)),
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              child: Text("New to NLB? Sign Up!"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => info()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
