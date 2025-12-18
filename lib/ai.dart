// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import "dart:async";

class Ai extends StatefulWidget {
  const Ai({super.key});

  @override
  State<Ai> createState() => _AiState();
}

class _AiState extends State<Ai> {
  Timer? typingTimer;
  final TextEditingController prompt = TextEditingController();
  String reply =
      "Loading... \n asking Claude about your book!"; // store Claude's reply here
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    activateorder66();
  }

  void activateorder66() async {
    String temp =
        "Info on book and why its a good read: " +
        services.passtoAI.toString() +
        ". if no book found return u failed to find book use more advanced md in response whilst being concise";
    isloading = true;
    setState(() {});
    final res = await services.askClaude(temp);
    isloading = false;
    setState(() {
      slowtype(res);
    });
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    prompt.dispose();
    super.dispose();
  }

  @override
  Future<void> getClaudeReply() async {
    if (prompt.text != "") {
      isloading = true;
      setState(() {});
      final res = await services.askClaude(
        prompt.text +
            "Context: user is thinking about this book:" +
            services.passtoAI.toString() +
            "use mode advanceded md in response whilst being concise",
      );
      isloading = false;
      setState(() {
        slowtype(res);
      });
    } else {}
  }

  void slowtype(String newText) {
    typingTimer?.cancel();

    final String oldText = reply; // current displayed reply
    int i = 0;

    final int steps =
        (oldText.length > newText.length) ? oldText.length : newText.length;

    typingTimer = Timer.periodic(Duration(milliseconds: 5), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      // prefix: new text typed so far
      final int newCut = i.clamp(0, newText.length);
      final String prefix = newText.substring(0, newCut);

      // suffix: remaining old text not replaced yet
      final String suffix = (i < oldText.length) ? oldText.substring(i) : "";

      setState(() {
        reply = prefix + suffix;
      });

      i++;

      if (i > steps) {
        t.cancel();
        // ensure final exact text
        if (mounted) {
          setState(() => reply = newText);
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Claude",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body:
          isloading
              ? Center(child: Expanded(child: CircularProgressIndicator()))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      width: 500,
                      child: TextField(
                        controller: prompt,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              getClaudeReply();
                            },
                            icon: Icon(Icons.search),
                          ),
                          labelText: "Enter prompt",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: MarkdownBody(data: reply, selectable: true),
                    ),
                  ),
                  Container(color: Colors.black, height: 80),
                ],
              ),
    );
  }
}
