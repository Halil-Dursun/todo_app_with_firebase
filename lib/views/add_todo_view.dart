
import 'package:firebase_todo_app/models/todo_model.dart';
import 'package:firebase_todo_app/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AddTodo extends StatefulWidget {
  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _todoController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Ekle'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _globalKey,
              child: TextFormField(
                validator: (value){
                  if(value != null && value.length>=1){
                    return null;
                  }else{
                    return 'Lütfen Birşeyler Giriniz';
                  }
                },
                controller: _todoController,
                decoration: InputDecoration(
                  labelText: 'Todo Giriniz',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: Text(DateFormat('d MMM yyyy, EEEE').format(dateTime)),
                trailing: IconButton(onPressed: (){
                  showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100)).then((value) {
                    setState(() {
                      dateTime = value ?? dateTime;
                    });
                  });
                }, icon: Icon(Icons.date_range)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                addTodo();
              },
              child: Text('Görevi Ekle'),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void addTodo() {
    if(_globalKey.currentState!.validate()){
      final FireStore _fs = FireStore();
      _fs.addTodo(TodoModel(todo: _todoController.text, dateTimeNow: DateTime.now(), dateTimeTodo: dateTime));
      Navigator.pop(context);
    }
  }

}
