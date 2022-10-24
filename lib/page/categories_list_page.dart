import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logif/databases/firestore_databases.dart';
import 'package:logif/page/card_page.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/widget/navigation_drawer_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Categorias de Estudo'),
          titleTextStyle: AppTheme.typo.scaffoldTitle,
          centerTitle: true,
        ),
        body: const CategoriesWidget());
  }
}

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  final FirebaseFirestore db = FirestoreDatabase.get();
  final _authUser = FirebaseAuth.instance.currentUser!;

  Stream<QuerySnapshot> _getCategories() {
    return db.collection('categories').orderBy('order').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getCategories(),
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Não possui categorias!'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                final DocumentSnapshot doc = snapshot.data!.docs[index];
                return buildCategory(doc, context, index);
              },
            );
        }
      },
    );
  }
}

Widget buildCategory(DocumentSnapshot doc, BuildContext context, int index) {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final String difficulty;
  final Color color;
  final totalCards = doc['total_cards'];
  final totalPoints = doc['value_points'];

  if (doc['difficulty'] == 1) {
    difficulty = 'Iniciante';
    color = AppTheme.colors.green;
  } else if (doc['difficulty'] == 2) {
    difficulty = 'Intermediário';
    color = AppTheme.colors.yellow;
  } else {
    difficulty = 'Avançado';
    color = AppTheme.colors.red;
  }

  return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CardPage(category: doc),
        ));
        debugPrint('voce clicou na categoria ' + doc['name']);
      },
      child: StreamBuilder<DocumentSnapshot?>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  var userTotalScore = user!['score'];
                  var userScores = user['scores'];

                  final double percentCompleted =
                      (userScores[doc['order']] / totalPoints) * 100.00;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: percentCompleted == 100
                          ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.green.shade100,
                                AppTheme.colors.green,
                              ],
                            )
                          : percentCompleted > 0 ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                AppTheme.colors.purple,
                                AppTheme.colors.darkPurple,
                              ],
                            ) : LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                AppTheme.colors.darkBackground,
                                Colors.black45,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        addVerticalSpace(40),
                        Text(doc['name'], style: AppTheme.typo.title),
                        addVerticalSpace(10),
                        Badge(
                          shape: BadgeShape.square,
                          borderRadius: BorderRadius.circular(6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          badgeContent: Text(difficulty.toUpperCase(),
                              style: AppTheme.typo.badgeText),
                          badgeColor: color,
                          toAnimate: false,
                        ),
                        addVerticalSpace(15),
                        CircularPercentIndicator(
                          radius: 30,
                          lineWidth: 7.0,
                          percent: percentCompleted / 100,
                          animation: true,
                          animationDuration: 1500,
                          center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(percentCompleted.toStringAsFixed(0) + '%',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700))
                              ]),
                          progressColor: Colors.white,
                        ),
                        addVerticalSpace(40),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.light,
                            border: Border.all(
                                width: 2, color: AppTheme.colors.lightGrey),
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                addSpace(),
                                Icon(Icons.library_books_outlined,
                                    color: AppTheme.colors.purple),
                                addHorizontalSpace(10),
                                Text('$totalCards Cards',
                                    style: AppTheme.typo.lightIconText),
                                addSpace(),
                                VerticalDivider(
                                    color: AppTheme.colors.lightGrey,
                                    width: 1,
                                    thickness: 2),
                                addSpace(),
                                Icon(Icons.workspace_premium_outlined,
                                    color: AppTheme.colors.purple),
                                addHorizontalSpace(10),
                                Text(
                                    '${userScores[doc['order']]}/$totalPoints Pontos',
                                    style: AppTheme.typo.lightIconText),
                                addSpace()
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('Houve um erro'));
                }
            }
          }));
}
