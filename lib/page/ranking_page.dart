import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logif/model/user.dart';
import 'package:logif/theme/app_theme.dart';
import '../widget/navigation_drawer_widget.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Ranking'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: readUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);

                return const Text(
                    'Ocorreu algum erro ao tentar recuperar o ranking');
              } else if (snapshot.hasData) {
                final users = snapshot.data!;

                return ListView(
                    padding: const EdgeInsets.all(15),
                    children:
                        (users as List<UserDatabase>).map(buildUser).toList());
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget buildUser(UserDatabase user) => Card(
      margin: EdgeInsets.only(bottom: 15.0),
      color: AppTheme.colors.darkBackgroundVariation,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(user.photo!)),
          title: Text(
            user.name.toString(),
            style: AppTheme.typo.title,
          ),
          subtitle: Text(
            user.score.toString() + ' pontos',
            style: TextStyle(fontFamily: 'Inter', fontSize: 14),
          ),
          trailing: Badge(
            badgeContent: Text(
              '1',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            toAnimate: false,
            badgeColor: AppTheme.colors.purple,
            padding: const EdgeInsets.all(12),
          )));

  Stream<List<UserDatabase>> readUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('score', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserDatabase.fromJson(doc.data()))
            .toList());
  }

  Future<UserDatabase?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserDatabase.fromJson(snapshot.data()!);
    }

    return null;
  }
}
