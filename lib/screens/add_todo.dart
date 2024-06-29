import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({
    super.key,
    this.todo
  });

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  // controllers to get value from form
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
        // isEdit?
      ),
      body: ListView(
        children:  [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isEdit? updateData: submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    isEdit? "Update Todo" : "Add Todo"
                ),
              ),
          )
        ],
      ),
    );
  }

  // function to submit form to server
  void submitData() async{
  // get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    // submit data to server
    final url = Uri.parse("https://api.nstack.in/v1/todos");
    final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
    );
    // show success or failure message
    if (response.statusCode == 201) {
      titleController.text = "";
      descriptionController.text = "";
      showSuccessMessage('Todo Created');
    } else {
      showErrorMessage("Failed to create todo");
    }
  }

  // function to update todo
  void updateData() async{
    // get todo from data
    final todo = widget.todo;
    if(todo == null ){
      showErrorMessage("You cannot update todo");
      return;
    }
    final id = todo['_id'];
    final title = todo['title'];
    final description = todo['description'];
    final isCompleted = todo['is_completed'];
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted
    };
    // submit data to server
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    // show success or failure message
    if (response.statusCode == 201) {
      titleController.text = "";
      descriptionController.text = "";
      showSuccessMessage('Todo Updated');
    } else {
      showErrorMessage("Failed to update todo");
    }
  }

  // success message function
  void showSuccessMessage(String message) {
    final snackBar =  SnackBar(
        content: Text(
            message,
            style: const TextStyle(color: Colors.white),
        ),
      backgroundColor: Colors.purple,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // error message function
  void showErrorMessage(String message) {
    final snackBar =  SnackBar(
        content: Text(
            message,
            style: const TextStyle(color: Colors.white),
        ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

