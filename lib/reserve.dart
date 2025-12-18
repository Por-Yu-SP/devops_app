// ignore_for_file: camel_case_types, unnecessary_string_interpolations

import 'package:devops_app/ai.dart';
import 'package:devops_app/homepage.dart';
import 'package:devops_app/service.dart';
import 'package:flutter/material.dart';

class reserve extends StatefulWidget {
  const reserve({super.key});

  @override
  State<reserve> createState() => _reserveState();
}

class _reserveState extends State<reserve> {
  final toomuch = SnackBar(
    content: Text(
      "Error too many books borrowed at once",
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: const Color.fromARGB(255, 255, 108, 108),
  );

  final TextEditingController Searchcontrol = TextEditingController();
  var filter = [];
  void filterfunc() {
    String query = Searchcontrol.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filter = List.from(
          services.loanable,
        ); // copy to avoid changing list from changing original
      } else {
        filter =
            services.loanable.where((item) {
              return item.title.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  @override
  initState() {
    super.initState();
    filter = List.from(services.loanable);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Reservations",
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
              "Reserve A Book!",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: Searchcontrol,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      filterfunc();
                    },
                    icon: Icon(Icons.search),
                  ),
                  labelText: "Enter Term",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: filter.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                title: Text("Confirm"),
                                content: Text(
                                  "Please confirm if you want to Reserve \n Would you like to find out more about this title using AI?",
                                ),
                                actions: [
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => reserve(),
                                        ),
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
                                      services.passtoAI = filter[index].title;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Ai(),
                                        ),
                                      );
                                    },
                                    child: Text("AI"),
                                  ),
                                  SizedBox(width: 20),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () async {
                                      var theindex = services.loanable.indexOf(
                                        filter[index],
                                      );
                                      if (services.reservedlist.length < 10) {
                                        await services.reserveBook(theindex);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(toomuch);
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => homepage(),
                                        ),
                                      );
                                    },
                                    child: Text("Confirm"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 145, 220, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: 400,
                          height: 60,
                          child: Center(
                            child: Text(
                              "${filter[index].title}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homepage()),
            );
          },
          color: Colors.white,
          icon: Icon(Icons.home),
        ),
      ),
    );
  }
}
