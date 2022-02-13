import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../views/home_page_view.dart';
import '../views/register_view.dart';

class FireBaseInitialize {
  final Future<FirebaseApp> _initialize = Firebase.initializeApp();

  firebaseInitialize() {
    return FutureBuilder(
        future: _initialize,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Bir hata oluştu'),
            );
          } else if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return HomePage();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Scaffold(
                      body:  Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return RegisterPage();
                  }
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
