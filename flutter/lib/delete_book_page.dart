import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book.dart';

class DeleteBookPage extends StatefulWidget {
  final int bookId;

  DeleteBookPage({required this.bookId});

  @override
  _DeleteBookPageState createState() => _DeleteBookPageState();
}

class _DeleteBookPageState extends State<DeleteBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Book'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Are you sure you want to delete this book?',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse('http://localhost:8080/deleteBook/${widget.bookId}'),
                  headers: {
                    'Authorization': 'Basic '+ base64Encode(utf8.encode('test:123456')),
                    "Content-Type": "application/json",
                  },
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Book deleted successfully')),
                  );
                  Navigator.pop(context); // Wróć do poprzedniej strony
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete book')),
                  );
                }
              },
              child: Text('Confirm Deletion'),
            ),
          ],
        ),
      ),
    );
  }
}
