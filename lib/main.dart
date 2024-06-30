import 'package:flutter/material.dart';
import 'package:new_project/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Crashlytics in release mode
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  try {
    // Code that might crash
  } catch (e, stack) {
    // Log the error with Crashlytics
    await FirebaseCrashlytics.instance.recordError(e, stack);
  }

  runApp(const App());
}