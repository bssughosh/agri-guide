import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'injection_container.dart' as di;
import 'my_app.dart';

void main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
