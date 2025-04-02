import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'author.dart'; 
import 'authors_list_page.dart';

class DeleteAuthorPage extends StatefulWidget {
  final Author author;
  final Function refreshAuthorsList;

  DeleteAuthorPage({required this.author, required this.refreshAuthorsList});

  @override
  _DeleteAuthorPageState createState() => _DeleteAuthorPageState();
}

class _DeleteAuthorPageState extends State<DeleteAuthorPage> {
  Future<void> _deleteAuthor() async {
    var url = Uri.parse('http://localhost:8080/deleteAuthor/${widget.author.id}');
    var response = await http.delete(url,
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
      },
    );

    if (response.statusCode == 200) {
      widget.refreshAuthorsList();
      Navigator.pop(context);
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Bad request: ${response.body}'),
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
    } else if (response.statusCode == 403) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Forbidden: ${response.body}'),
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
    } else if (response.statusCode == 500) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Internal server error: ${response.body}'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete author: ${response.body}'),
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
        title: Text('Delete Author'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Are you sure you want to delete ${widget.author.firstName} ${widget.author.lastName}?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteAuthor,
              child: Text('Yes, delete'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No, cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}
}
