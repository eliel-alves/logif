import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logif/model/user.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/widget/navigation_drawer_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        titleTextStyle: AppTheme.typo.subtitle,
        centerTitle: true,
      ),
      body: FutureBuilder<UserDatabase?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                  'Ocorreu algum erro ao tentar recuperar o usuário');
            } else if (snapshot.hasData) {
              final user = snapshot.data;

              return user == null
                  ? const Center(child: Text('Usuário não encontrado'))
                  : buildUser(user);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget buildUser(UserDatabase user) => Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photo!),
            ),
            addVerticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.name!,
                  style: AppTheme.typo.title,
                ),
                addHorizontalSpace(10),
                Icon(Icons.verified, color: AppTheme.colors.purple, size: 20)
              ],
            ),
            addVerticalSpace(10),
            buildInfoIcon(Icons.mail_outline, user.email!),
            addVerticalSpace(10),
            buildInfoIcon(Icons.workspace_premium_outlined,
                user.score.toString() + ' Pontos'),
            addVerticalSpace(10),
            buildInfoIcon(
                Icons.person_outline, Utils.dateConverter(user.creationDate!))
          ],
        ),
      );

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

  Widget buildInfoIcon(IconData icon, String text) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.colors.purple),
            addHorizontalSpace(10),
            Text(
              text,
              style: AppTheme.typo.normal,
            )
          ]);
}
