import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logif/databases/firestore_databases.dart';
import 'package:logif/theme/app_theme.dart';
import 'package:logif/utils/helper_widgets.dart';
import 'package:logif/widget/navigation_drawer_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirestoreDatabase.get();
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Perfil'),
        titleTextStyle: AppTheme.typo.subtitle,
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            addVerticalSpace(10),
            Text(
              user.displayName!,
              style: AppTheme.typo.title,
            ),
            addVerticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline, color: AppTheme.colors.purple),
                addHorizontalSpace(10),
                Text(
                  user.email!,
                  style: AppTheme.typo.normal,
                )
              ],
            ),
            addVerticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.workspace_premium_outlined, color: AppTheme.colors.purple),
                addHorizontalSpace(10),
                Text(
                  'Pontos',
                  style: AppTheme.typo.normal,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}