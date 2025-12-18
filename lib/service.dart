import "package:cloud_firestore/cloud_firestore.dart";

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

class services {
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

  static Future<void> extendreserve(int index) async{
    for (int i=0;i<booklist.length;i++)
    {
      if(booklist[i].id==reservedlist[index].id)
      {
        QuerySnapshot qs= await book.limit(1).where("id", isEqualTo: booklist[i].id).get();
        DocumentSnapshot doc =qs.docs[0];
        await doc.reference.update({
          "extended":true,
        });
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
