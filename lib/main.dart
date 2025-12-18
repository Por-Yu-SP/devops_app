import 'package:devops_app/service.dart';
import 'package:devops_app/signIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await services.getAllProfile();
  runApp(MaterialApp(home: SignIn()));
}
