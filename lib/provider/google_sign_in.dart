import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      debugPrint("Começou Google Login");
      final googleUser = await googleSignIn.signIn();
      debugPrint("Terminou a função Google Sign In Google Login");

      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential newUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint('Id usuario: ' + newUser.user!.uid);

      // Adiciona usuário ao Users
      bool userExist = await checkUserExist(newUser.user?.uid);
      if (!userExist) {
        debugPrint('USUARIO NAO EXISTE');     

        await updateUserData(newUser.user?.uid, newUser.user?.email,
            newUser.user?.displayName, newUser.user?.photoURL);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    debugPrint('Desconectou');
    FirebaseAuth.instance.signOut();
  }

  // Função que checa se o usuario ja existe no banco ou nao
  Future<bool> checkUserExist(String? uid) async {
    try {
      var doc = await users.doc(uid).get();

      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  // Atualiza novos campos para o novo usuario
  Future updateUserData(
      String? uid, String? email, String? fullName, String? urlPhoto) async {
    Timestamp timeNow = Timestamp.fromDate(DateTime.now());

    return await users.doc(uid).set({
      'name': fullName,
      'email': email,
      'url_photo': urlPhoto,
      'score': 0,
      'categories_score': [],
      'creation_date': timeNow,
    });
  }
}
