import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'author.dart';
import 'authors_list_page.dart';

class UpdateAuthorPage extends StatefulWidget {
  final Author author;
  final Function refreshAuthorsList;

  UpdateAuthorPage({required this.author, required this.refreshAuthorsList});

  @override
  _UpdateAuthorPageState createState() => _UpdateAuthorPageState();
}

class _UpdateAuthorPageState extends State<UpdateAuthorPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.author.firstName?? "";
    _lastNameController.text = widget.author.lastName?? "";
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _updateAuthor() async {
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/updateAuthor'),
      headers: {
        'Authorization': 'Basic '+ base64Encode(utf8.encode('test:123456')),
         "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode({
        "id": widget.author.id,
        "firstName": firstName,
        "lastName": lastName,
      }),
    );

    if (response.statusCode == 200) {
      _firstNameController.clear();
      _lastNameController.clear();

      widget.refreshAuthorsList();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      String errorMessage = 'An error occurred while updating the author';
      if (response.statusCode == 400) {
        errorMessage = 'Validation error: Please check the input fields';
      } else if (response.statusCode == 500) {
        errorMessage = 'Server error: Please try again later';
      } else if (response.statusCode == 403) {
        errorMessage = 'Forbidden: You do not have permission to perform this action.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.deepPurple, Colors.green],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Update author'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'firstName'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'lastName'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateAuthor,
                child: Text('Update author'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
