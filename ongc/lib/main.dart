import "package:flutter/material.dart";
import "package:ongc/background_services.dart";
import "package:ongc/login.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  runApp(
    const MaterialApp(
      home: SignUp(),
    ),
  );
}
