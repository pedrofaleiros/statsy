import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:statsy/app_widget.dart';
import 'package:statsy/firebase_options.dart';
import 'package:statsy/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  await dotenv.load(fileName: ".env");

  runApp(const AppWidget());
}
