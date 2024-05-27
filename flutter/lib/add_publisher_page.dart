import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'publisher.dart';

class AddPublisherPage extends StatefulWidget {
  final Function refreshPublishersList;

  AddPublisherPage({required this.refreshPublishersList});

  @override
  _AddPublisherPageState createState() => _AddPublisherPageState();
}

class _AddPublisherPageState extends State<AddPublisherPage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addPublisher() async {
    final String name = _nameController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a name for the publisher'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Encode username and password
    final encodedCredentials = 'Basic ' + base64Encode(utf8.encode('test:123456'));

    final response = await http.put(
      Uri.parse('http://localhost:8080/addPublisher'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": encodedCredentials,
      },
      body: jsonEncode({
        "name": name,
      }),
    );

    if (response.statusCode == 201) {
      _nameController.clear();
      widget.refreshPublishersList(); 

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Publisher successfully added'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      String errorMessage = 'An error occurred while adding the publisher';
      if (response.statusCode == 400) {
        errorMessage = 'Validation error: Please check the input fields';
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        errorMessage = 'Unauthorized: Invalid username or password';
      } else if (response.statusCode == 500) {
        errorMessage = 'Server error: Please try again later';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add publisher'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple, Colors.green],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addPublisher,
                child: Text('Add publisher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
