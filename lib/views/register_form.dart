import 'package:firebase_todo_app/controller/register_form_controller.dart';
import 'package:firebase_todo_app/models/user_model.dart';
import 'package:firebase_todo_app/service/auth_service.dart';
import 'package:firebase_todo_app/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserModel userModel = UserModel(username: '', email: '', password: '');
  bool loginOrRegister = false;
  final RegisterFormController _registerFormController =
      Get.put(RegisterFormController());

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Form(
      key: _key,
      child: Container(
        width: _width,
        height: _height,
        child: Obx(()=>ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: _height / 5,
              child: Image.asset('images/todo.jpg'),
            ),
            if (!_registerFormController.loginOrRegister.value)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    userModel.username = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kullanıcı adı boş bırakılamaz';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  userModel.email = value;
                },
                validator: (value) {
                  if (value != null &&
                      value.length > 8 &&
                      value.contains('@')) {
                    return null;
                  } else {
                    return 'Hatalı mail formatı';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: _registerFormController.obscureText.value,
                onChanged: (value) {
                  userModel.password = value;
                },
                validator: (value) {
                  if (value != null && value.length >= 8) {
                    return null;
                  } else {
                    return 'Şifre 8 karakterden uzun olmalıdır';
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: _registerFormController.obscureText.value
                      ? IconButton(
                      onPressed: () {
                        _registerFormController.changeObscureText();
                      }, icon: Icon(Icons.visibility_off))
                      : IconButton(
                      onPressed: () {
                        _registerFormController.changeObscureText();
                      }, icon: Icon(Icons.visibility)),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            _registerFormController.loginOrRegister.value
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text('Giriş Yap'),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  register();
                },
                child: Text('Kayıt Ol'),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),
            ),
            _registerFormController.loginOrRegister.value
                ? TextButton(
                onPressed: () {
                  _registerFormController.changeLoginOrRegister();
                },
                child: Text('Bir hesabım yok...'))
                : TextButton(
              onPressed: () {
                _registerFormController.changeLoginOrRegister();
              },
              child: Text('Zaten hesabım var...'),
            ),
          ],
        ),),
      ),
    );
  }

  void login() {
    if (_key.currentState!.validate()) {
      Auth().login(userModel);
    }
  }

  void register() async {
    if (_key.currentState!.validate()) {
      String uid = await Auth().register(userModel);
      if (uid != null && uid.length > 0) {
        FireStore().addUser(userModel, uid);
      }
    }
  }
}
