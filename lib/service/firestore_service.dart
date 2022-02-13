import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/models/todo_model.dart';
import 'package:firebase_todo_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final Stream streamTodos = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos')
      .snapshots();

  Future<void> addUser(UserModel model, String uid) async {
    await usersRef.doc('${uid}').set({
      'username': model.username,
      'email': model.email,
    }).then((value) {
      print('Kullanıcı eklendi ');
    }).catchError((e) {
      print(e);
    });
  }

  Future<UserModel> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(user!.uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return UserModel(
        username: data['username'], email: data['email'], password: '');
  }

  Future<void> updateUser(UserModel model) async {
    User? user = FirebaseAuth.instance.currentUser;
    await _firestore.collection('users').doc(user!.uid).set({
      'email': model.email,
      'username': model.username,
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Bilgileriniz Güncellendi",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((e) {
      debugPrint(e);
      Fluttertoast.showToast(
          msg: "Bilgileriniz Güncellenemedi.Bir hata oluştu.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future<void> addTodo(TodoModel todoModel) async {
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .add({
      'todo': todoModel.todo,
      'todo_time': todoModel.dateTimeTodo,
      'date_time_now': todoModel.dateTimeNow,
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Todo Eklendi",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((e) {
      debugPrint(e);
      Fluttertoast.showToast(
          msg: "Kayıt başarısız",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future<void> deleteTodo(DocumentReference reference) async {
    await reference.delete().then((value) {
      Fluttertoast.showToast(
          msg: "Todo silindi",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((e) {
      debugPrint(e);
      Fluttertoast.showToast(
          msg: "Todo silme işlemi başarısız",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
