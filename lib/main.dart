import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logif/firebase_options.dart';
import 'package:logif/page/home_page.dart';
import 'package:logif/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = 'Página Inicial';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData.dark().copyWith(accentColor: Colors.indigo),
      home: HomePage(),
    )
  );
}