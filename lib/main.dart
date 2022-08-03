import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logif/firebase_options.dart';
import 'package:logif/page/home_page.dart';
import 'package:logif/provider/google_sign_in.dart';
import 'package:logif/theme/theme_constants.dart';
import 'package:logif/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = 'Página Inicial';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: HomePage(),
    )
  );
}