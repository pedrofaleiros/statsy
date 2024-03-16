import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:statsy/app_widget.dart';
import 'package:statsy/utils/firebase_options.dart';
import 'package:statsy/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(const AppWidget());
}
