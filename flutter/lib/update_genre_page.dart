import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'genre.dart';
import 'genre_list_page.dart';

class UpdateGenrePage extends StatefulWidget {
  final Genre genre;
  final Function refreshGenresList;

  UpdateGenrePage({required this.genre, required this.refreshGenresList});

  @override
  _UpdateGenrePageState createState() => _UpdateGenrePageState();
}

class _UpdateGenrePageState extends State<UpdateGenrePage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.genre.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateGenre() async {
    final String name = _nameController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/updateGenre'),
      headers: {
        'Authorization': 'Basic '+ base64Encode(utf8.encode('test:123456')),
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode({
        "id": widget.genre.id,
        "name": name,
      }),
    );

    if (response.statusCode == 200) {
      _nameController.clear();
      widget.refreshGenresList();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Genre updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      String errorMessage = 'An error occurred while updating the genre';
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Validation error: Please check the input fields';
          break;
        case 404:
          errorMessage = 'Genre not found';
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
        title: Text('Update genre'),
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
              onPressed: _updateGenre,
              child: Text('Update genre'),
            ),
          ],
        ),
      ),
    );
  }
}
