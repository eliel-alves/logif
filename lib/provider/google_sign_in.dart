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
      final googleUser = await googleSignIn.signIn();

      if(googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential newUser = await FirebaseAuth.instance.signInWithCredential(credential);
      print('Id usuario: ' + newUser.user!.uid);

      // Adiciona usuário ao Users
      bool userExist = await checkUserExist(newUser.user?.uid);
      if(!userExist) {
        print('USUARIO NAO EXISTE');
        await updateUserData(newUser.user?.uid, newUser.user?.email, newUser.user?.displayName, newUser.user?.photoURL);
      }

    } catch (e){
      print(e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  // Função que checa se o usuario ja existe no banco ou nao
  Future<bool> checkUserExist(String? uid) async {
    try {
      var doc = await users.doc(uid).get();

      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  // Atualiza novos campos para o novo usuario
  Future updateUserData(String? uid, String? email, String? fullName, String? urlPhoto) async {
    Timestamp timeNow = Timestamp.fromDate(DateTime.now());

    return await users.doc(uid).set({
      'name' : fullName,
      'email' : email,
      'url_photo' : urlPhoto,
      'score' : 0,
      'completed_categories' : [],
      'creation_date' : timeNow,
    });
  }

}