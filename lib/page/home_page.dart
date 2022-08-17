import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logif/page/categories_list_page.dart';
import 'package:logif/page/sign_up_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const CategoriesPage();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Ocorreu algum erro!'));
            } else {
              return const SignUpPage();
            }
          },
        ),
      );
}
