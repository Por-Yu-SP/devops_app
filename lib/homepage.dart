// ignore_for_file: camel_case_types

import 'package:devops_app/map.dart';
import 'package:devops_app/viewloan.dart';
import 'package:flutter/material.dart';
import 'service.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController idcontrol = TextEditingController();
  TextEditingController titlecontrol = TextEditingController();
  TextEditingController locationcontrol = TextEditingController();
  TextEditingController control = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "HomePage",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome to NLB",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 300),
            SizedBox(
              height: 60,
              width: 300,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => map()),
                  );
                },
                child: Text(
                  "Reserve Books",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: 300,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewLoan()),
                  );
                },
                child: Text(
                  "View Loaned Books",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            /*
            FilledButton(onPressed: (){
              print("go to ");
            }, child: Text("Reserve Books",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
            */
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                title: Text("Confirm"),
                content: SizedBox(
                  height: 250,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: TextField(
                          controller: idcontrol,
                          decoration: InputDecoration(
                            labelText: "Enter id",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: TextField(
                          controller: titlecontrol,
                          decoration: InputDecoration(
                            labelText: "Enter title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: TextField(
                          controller: locationcontrol,
                          decoration: InputDecoration(
                            labelText: "Enter location no",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => homepage()),
                      );
                    },
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 20),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      await services.addbook(
                        idcontrol.text,
                        titlecontrol.text,
                        "",
                        "",
                        false,
                        false,
                        false,
                        locationcontrol.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => homepage()),
                      );
                    },
                    child: Text("Confirm"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
