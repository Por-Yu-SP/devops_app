import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class Profile {
  String adm = "", password = "";
  // Constructor - will run when creating an Art object
  Profile(this.adm, this.password);
}

class Book {
  String location = "", id = "", title = "", loanadm = "", date = "";
  bool extended = false, reserved = false, onloan = false;

  // Constructor - will run when creating an Art object
  Book(
    this.id,
    this.title,
    this.loanadm,
    this.date,
    this.extended,
    this.reserved,
    this.onloan,
    this.location,
  );
}

class ClaudeApi {
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  final String apiKey;
  final String model;

  const ClaudeApi({
    required this.apiKey,
    this.model = 'claude-sonnet-4-5-20250929',
  });

  Future<String> ask(String prompt, {int maxTokens = 800}) async {
    final body = {
      "model": model,
      "max_tokens": maxTokens,
      "messages": [
        {"role": "user", "content": prompt},
      ],
    };

    final resp = await http.post(
      Uri.parse(_endpoint),
      headers: {
        "content-type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final content = (data["content"] as List?) ?? const [];
    if (content.isEmpty) return '';
    // Each item is like {"type":"text","text":"..."}
    return content.map((e) => (e as Map)["text"] ?? '').join("\n").trim();
  }
}

class services {
  static String key = "";
  static String passtoAI = "";
  static String tappedLocation = "";
  static var adm = "";
  static var password = "";
  static int index = -1;
  static List<Profile> profilelist = [];
  static List<Book> booklist = [];
  static List<Book> reservedlist = [];
  static List<Book> loanable = [];
  static CollectionReference profile = FirebaseFirestore.instance.collection(
    "profile",
  );
  static CollectionReference book = FirebaseFirestore.instance.collection(
    "books",
  );
  //download all firebase profiles to local
  static Future<void> getAllProfile() async {
    profilelist.clear();
    QuerySnapshot qs = await profile.get();
    for (int i = 0; i < qs.docs.length; i++) {
      DocumentSnapshot doc = qs.docs[i];
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      profilelist.add(Profile(data["adm"], data["password"]));
    }
  }

  static getkey() async {
    key = (await rootBundle.loadString('assets/api.txt')).trim();
  }

  //API KEYYYY
  static final String _apiKey = key;

  // Model name in one place

  static final _claude = ClaudeApi(apiKey: _apiKey);

  static Future<String> askClaude(String userPrompt, {int maxTokens = 812}) {
    return _claude.ask(userPrompt, maxTokens: maxTokens);
  }

  //check against list for correct profile and password
  static bool verifypass(var admin, var password) {
    for (int i = 0; i < profilelist.length; i++) {
      if (profilelist[i].adm == admin) {
        adm = admin;
        if (profilelist[i].password == password) {
          index = i;
          return true;
        }
      }
    }
    return false;
  }

  static void addProfile() async {
    profilelist.add(Profile(adm, password));
    for (int i = 0; i < profilelist.length; i++) {
      if (profilelist[i].adm == adm) {
        if (profilelist[i].password == password) {
          index = i;
        }
      }
    }
    final DocumentReference dr = await profile.add({
      "adm": adm,
      "password": password,
      "fine": 0.0,
    });
    dr.id;
  }

  static Future<void> extendreserve(int index) async {
    for (int i = 0; i < booklist.length; i++) {
      if (booklist[i].id == reservedlist[index].id) {
        QuerySnapshot qs =
            await book.limit(1).where("id", isEqualTo: booklist[i].id).get();
        DocumentSnapshot doc = qs.docs[0];
        await doc.reference.update({"extended": true});
      }
    }
    await getAllbook();
  }

  static Future<void> getAllbook() async {
    booklist.clear();
    loanable.clear();
    reservedlist.clear();
    QuerySnapshot qs = await book.get();
    for (int i = 0; i < qs.docs.length; i++) {
      DocumentSnapshot doc = qs.docs[i];
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      booklist.add(
        Book(
          data["id"],
          data["title"],
          data["loanadm"],
          data["date"],
          data["extended"],
          data["reserved"],
          data["onloan"],
          data["location"],
        ),
      );

      if (data["onloan"] != true &&
          data["reserved"] != true &&
          data["location"] == tappedLocation) {
        loanable.add(
          Book(
            data["id"],
            data["title"],
            data["loanadm"],
            data["date"],
            data["extended"],
            data["reserved"],
            data["onloan"],
            data["location"],
          ),
        );
      }
      if (data["loanadm"] == adm) {
        reservedlist.add(
          Book(
            data["id"],
            data["title"],
            data["loanadm"],
            data["date"],
            data["extended"],
            data["reserved"],
            data["onloan"],
            data["location"],
          ),
        );
      }
    }
  }

  static Future<void> reserveBook(int index) async {
    for (int i = 0; i < booklist.length; i++) {
      if (loanable[index].id == booklist[i].id) {
        booklist[i].reserved = true;
        //get the current date
        DateTime now = DateTime.now();
        String dateOnly = now.toString().split(' ')[0];
        QuerySnapshot qs =
            await book.limit(1).where("id", isEqualTo: booklist[i].id).get();
        DocumentSnapshot doc = qs.docs[0];
        await doc.reference.update({
          "loanadm": adm,
          "date": dateOnly,
          "reserved": true,
        });
      }
    }
    await getAllbook();
  }

  static Future<void> addbook(
    String id,
    String title,
    String loanadm,
    String date,
    bool extended,
    bool reserved,
    bool onloan,
    String location,
  ) async {
    Map<String, String> locationmap = {
      "1": "Woodlands Regional",
      "2": "Sembawang Library",
    };
    booklist.add(
      Book(id, title, loanadm, date, extended, reserved, onloan, location),
    );
    final DocumentReference dr = await book.add({
      "id": id,
      "title": title,
      "loanadm": loanadm,
      "date": date,
      "extended": extended,
      "reserved": reserved,
      "onloan": onloan,
      "location": locationmap[location],
    });
    dr.id;
  }

  static Future<void> selectlocation() async {
    await getAllbook();
  }
}
