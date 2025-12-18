// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:devops_app/scanner.dart';
import 'package:devops_app/signIn.dart';
import 'package:flutter/material.dart';
import 'service.dart';

class info extends StatefulWidget {
  const info({super.key});

  @override
  State<info> createState() => _infoState();
}

class _infoState extends State<info> {
  final TextEditingController admcontrol = TextEditingController();
  final TextEditingController pass1control = TextEditingController();
  final TextEditingController pass2control = TextEditingController();
  final passSnack = SnackBar(
    content: Text("Error Passwords do not match"),
    duration: Duration(seconds: 5),
    backgroundColor: Colors.red,
  );
  final missSnack = SnackBar(
    content: Text("Error Missing Fields"),
    duration: Duration(seconds: 5),
    backgroundColor: Colors.red,
  );
  void signupfunc() {
    if (admcontrol.text.trim().isEmpty || pass1control.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(missSnack);
    } else {
      if (pass1control.text == pass2control.text) {
        services.adm = admcontrol.text;
        services.password = pass1control.text;
        services.addProfile();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(passSnack);
      }
    }
  }

  void scan() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const Scanner()),
    );

    if (result != null) {
      admcontrol.text = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Enter your details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 500,
                child: TextField(
                  controller: admcontrol,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        scan();
                      },
                      icon: Icon(Icons.camera),
                    ),
                    labelText: "Enter Admin Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 500,
                child: TextField(
                  controller: pass1control,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 500,
                child: TextField(
                  controller: pass2control,
                  decoration: InputDecoration(
                    labelText: "Confirm Pass",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 165),
            SizedBox(
              width: 150,
              height: 45,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  signupfunc();
                },
                child: Text("Sign Up", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
