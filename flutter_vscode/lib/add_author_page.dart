import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'author.dart';
import 'authors_list_page.dart';

class AddAuthorPage extends StatefulWidget {
  final VoidCallback refreshAuthorsList;

  AddAuthorPage({required this.refreshAuthorsList});

  @override
  _AddAuthorPageState createState() => _AddAuthorPageState();
}

class _AddAuthorPageState extends State<AddAuthorPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _addAuthor() async {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

    final response = await http.put(
       Uri.parse('http://localhost:8080/addAuthor'),
    headers: {
      'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
    }),
    );

    if (response.statusCode == 201) {
      _firstNameController.clear();
      _lastNameController.clear();
      widget.refreshAuthorsList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author successfully added'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Validation error: Please check the input fields'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (response.statusCode == 403) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Forbidden: You do not have permission to add authors'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred'),
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
          title: Text('Add author'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addAuthor,
                child: Text('Add author'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
