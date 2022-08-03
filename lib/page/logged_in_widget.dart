import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logif/databases/firestore_databases.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/widget/navigation_drawer_widget.dart';

class LoggedInMainPage extends StatefulWidget {
  const LoggedInMainPage({Key? key}) : super(key: key);

  @override
  _LoggedInMainPageState createState() => _LoggedInMainPageState();
}

class _LoggedInMainPageState extends State<LoggedInMainPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Categorias de Estudo'),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.colors.light,
      body: const CategoriesWidget()
    );
  }
}

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget>{
  final FirebaseFirestore db = FirestoreDatabase.get();
  final user = FirebaseAuth.instance.currentUser!;

  Stream<QuerySnapshot> _getCategories() {
    return db.collection('categories').orderBy('order').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _getCategories(),
        builder: (_, snapshot){
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('Não possui categorias!', style: TextStyle(color: AppTheme.colors.dark))
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_,index) {
                  final DocumentSnapshot doc = snapshot.data!.docs[index];
                  return _category(doc);
                },
              );
          }
        },
      ),
    );
  }
}

Widget _category(DocumentSnapshot doc) {
  final String difficulty;
  final Color color;
  final totalCards = doc['total_cards'];
  final totalPoints = doc['value_points'];

  if(doc['difficulty'] == 1) {
    difficulty = 'Iniciante';
    color = AppTheme.colors.green;
  } else if(doc['difficulty'] == 2) {
    difficulty = 'Intermediário';
    color = AppTheme.colors.yellow;
  } else {
    difficulty = 'Avançado';
    color = AppTheme.colors.red;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: AppTheme.colors.background,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        addVerticalSpace(40),
        Text(doc['name'], style: AppTheme.typo.title),
        addVerticalSpace(10),
        Badge(
          shape: BadgeShape.square,
          borderRadius: BorderRadius.circular(6),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          badgeContent: Text(difficulty.toUpperCase(), style: AppTheme.typo.badgeText),
          badgeColor: color,
          toAnimate: false,
        ),
        addVerticalSpace(40),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppTheme.colors.light,
            border: Border.all(width: 2, color: AppTheme.colors.lightGrey),
            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                addSpace(),

                Icon(Icons.library_books_outlined, color: AppTheme.colors.purple),
                addHorizontalSpace(10),
                Text('$totalCards Cards', style: AppTheme.typo.lightIconText),

                addSpace(),
                VerticalDivider(color: AppTheme.colors.lightGrey, width: 1, thickness: 2),
                addSpace(),

                Icon(Icons.workspace_premium_outlined, color: AppTheme.colors.purple),
                addHorizontalSpace(10),
                Text('$totalPoints Pontos', style: AppTheme.typo.lightIconText),

                addSpace()
              ],
            ),
          ),
        )
      ],
    ),
  );
}