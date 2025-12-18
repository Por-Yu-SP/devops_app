import 'package:devops_app/homepage.dart';
import 'package:flutter/material.dart';
import 'service.dart';

class ViewLoan extends StatefulWidget {
  const ViewLoan({super.key});

  @override
  State<ViewLoan> createState() => _ViewLoanState();
}

class _ViewLoanState extends State<ViewLoan> {
  final alrextended = SnackBar(
    content: Text(
      "Error Already extended",
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: const Color.fromARGB(255, 255, 108, 108),
  );
  @override
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
              "Your reservations!",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: services.reservedlist.length,
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
                                  "Please confirm if you want to Extend",
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
                                          builder: (context) => ViewLoan(),
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
                                      if (services
                                              .reservedlist[index]
                                              .extended !=
                                          true) {
                                        services.extendreserve(index);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(alrextended);
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
                          height: 90,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "${services.reservedlist[index].title}",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Loaned on ${services.reservedlist[index].date}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "At ${services.reservedlist[index].location}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
