import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/models/user_model.dart';
import 'package:firebase_todo_app/service/auth_service.dart';
import 'package:firebase_todo_app/service/firestore_service.dart';
import 'package:firebase_todo_app/views/add_todo_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireStore _fireStore = FireStore();
  UserModel model = UserModel(username: '', email: '', password: '');
  @override
  void initState() {
    getModel();
    super.initState();
  }
  void getModel() async{
    model = await _fireStore.getUser();
    debugPrint(model.email.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodo()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Auth().logOut();
          }, icon: Icon(Icons.logout)),
        ],
        title: Text('HomePage'),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  final FireStore _fireStore = FireStore();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      height: _height,
      width: _width,
      child: StreamBuilder(
        stream: _fireStore.streamTodos,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return const Center(child: Text('Bir hata oluştu'),);
          }else if(snapshot.data == null){
            return const Center(child: Text('Henüz bi görev eklemediniz'),);
          }else{
            List<DocumentSnapshot> list = snapshot.data.docs;
            return ListView.builder(itemCount: list.length,scrollDirection: Axis.vertical,shrinkWrap: true,itemBuilder: (BuildContext context,index){
              DocumentSnapshot documentSnapshot = list[index];
              Map<String,dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
              var todoDate = (data['todo_time'] as Timestamp).toDate();
              var addTodoDate = (data['date_time_now'] as Timestamp).toDate();
              return Container(
                child: Card(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black54,
                      width: 2.0
                    )
                  ),
                  child: ListTile(
                    trailing: IconButton(onPressed: (){
                      _fireStore.deleteTodo(documentSnapshot.reference);
                    }, icon: Icon(Icons.delete)),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(data['todo'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey),),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Görev Tarihi : ' + DateFormat('d MMM yyyy, EEEE').format(todoDate).toString(),style: TextStyle(fontSize: 14,color: Colors.black),),
                          Text('Görevin Eklenme Tarihi : '+DateFormat('d MMM yyyy, EEEE').format(addTodoDate).toString(),style: TextStyle(fontSize: 14,color: Colors.black),)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          }
        },
      ),
    );
  }
}

