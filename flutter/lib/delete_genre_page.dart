import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'genre.dart';
import 'genre_list_page.dart';

class DeleteGenrePage extends StatefulWidget {
  final Genre genre;
  final Function refreshGenreList;

  DeleteGenrePage({required this.genre, required this.refreshGenreList});

  @override
  _DeleteGenrePageState createState() => _DeleteGenrePageState();
}

class _DeleteGenrePageState extends State<DeleteGenrePage> {
  Future<void> _deleteGenre() async {
    final String genreId = widget.genre.id.toString();
    final response = await http.delete(
      Uri.parse('http://localhost:8080/deleteGenre/$genreId'),
      headers: {
        'Authorization': 'Basic '+ base64Encode(utf8.encode('test:123456')),
      },
    );

    if (response.statusCode == 200) {
      widget.refreshGenreList();
      Navigator.pop(context);
    } else {
      String errorMessage = 'Failed to delete genre';
      if (response.statusCode == 400) {
        errorMessage = 'Bad Request: ${response.body}';
      } else if (response.statusCode == 404) {
        errorMessage = 'Not Found: Genre not found';
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
        title: Text('Delete Genre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Are you sure you want to delete ${widget.genre.name}?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteGenre,
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
