import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'publisher.dart';
import 'publishers_list_page.dart';

class UpdatePublisherPage extends StatefulWidget {
  final Publisher publisher;
  final Function refreshPublishersList;

  UpdatePublisherPage({required this.publisher, required this.refreshPublishersList});

  @override
  _UpdatePublisherPageState createState() => _UpdatePublisherPageState();
}

class _UpdatePublisherPageState extends State<UpdatePublisherPage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.publisher.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updatePublisher() async {
    final String name = _nameController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/updatePublisher'),
      headers: {
        'Authorization': 'Basic '+ base64Encode(utf8.encode('test:123456')),
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode({
        "id": widget.publisher.id,
        "name": name,
      }),
    );

    if (response.statusCode == 200) {
      _nameController.clear();
      widget.refreshPublishersList();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Publisher updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      String errorMessage = 'An error occurred while updating the publisher';
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Validation error: Please check the input fields';
          break;
        case 404:
          errorMessage = 'Publisher not found';
          break;
        case 403:
          errorMessage = 'Forbidden: You do not have permission to perform this action.';
          break;
        default:
          errorMessage = 'Server error: Please try again later';
          break;
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
        title: Text('Update publisher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'name'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updatePublisher,
              child: Text('Update publisher'),
            ),
          ],
        ),
      ),
    );
  }
}
