import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/models/user_model.dart';
import 'package:flutter/material.dart';

import '../src/toast_message.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentUser = FirebaseAuth.instance.currentUser;

  Future<String> register(UserModel model) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: model.email, password: model.password);
      ToastMessage.longMessage(msg: 'Kayıt başarılı', color: Colors.green);
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ToastMessage.shortMessage(msg: 'Düşük seviyeli şifre', color: Colors.red);

      } else if (e.code == 'email-already-in-use') {
        ToastMessage.shortMessage(msg: 'Bu email adresine ait hesap bulunmakta', color: Colors.red);
      }
    } catch (e) {
      print(e);
      ToastMessage.shortMessage(msg: 'Beklenmeyen bir hata oluştu', color: Colors.red);
    }
    return '';
  }

  Future<void> login(UserModel model) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: model.email, password: model.password);
      ToastMessage.longMessage(msg: 'Giriş başarılı', color: Colors.green);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ToastMessage.shortMessage(msg: 'Kullanıcı bulunamadı', color: Colors.red);

      } else if (e.code == 'wrong-password') {
        ToastMessage.shortMessage(msg: 'Hatalı şifre girişi', color: Colors.red);

      }
    }
  }

  void logOut(){
    _firebaseAuth.signOut().then((value) {
      ToastMessage.longMessage(msg: 'Çıkış işlemi başarılı', color: Colors.green);
    }).catchError((e){
      ToastMessage.shortMessage(msg: 'Çıkış işlemi yapılırken hata oluştu', color: Colors.red);
    });
  }
}
