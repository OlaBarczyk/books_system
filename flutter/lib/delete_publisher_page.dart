import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'publisher.dart';
import 'publishers_list_page.dart';

class DeletePublisherPage extends StatefulWidget {
  final Publisher publisher;
  final Function refreshPublishersList;

  DeletePublisherPage({required this.publisher, required this.refreshPublishersList});

  @override
  _DeletePublisherPageState createState() => _DeletePublisherPageState();
}

class _DeletePublisherPageState extends State<DeletePublisherPage> {
  Future<void> _deletePublisher() async {
    final String publisherId = widget.publisher.id.toString();
    final response = await http.delete(
      Uri.parse('http://localhost:8080/deletePublisher/$publisherId'),
      headers: {
        'Authorization': 'Basic '+ base64Encode(utf8.encode('test:123456')),
      },
    );

    if (response.statusCode == 200) {
      widget.refreshPublishersList();
      Navigator.pop(context);
    } else {
      String errorMessage = 'Failed to delete publisher';
      if (response.statusCode == 400) {
        errorMessage = 'Bad Request: ${response.body}';
      } else if (response.statusCode == 404) {
        errorMessage = 'Not Found: Publisher not found';
      } else if (response.statusCode == 403) {
        errorMessage = 'Forbidden: You do not have permission to perform this action.';
      } else if (response.statusCode == 500) {
        errorMessage = 'Internal Server Error: ${response.body}';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Publisher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Are you sure you want to delete ${widget.publisher.name}?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deletePublisher,
              child: Text('Yes, delete'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No, cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
