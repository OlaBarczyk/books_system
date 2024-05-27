import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authors_list_page.dart';
import 'publishers_list_page.dart';
import 'genre_list_page.dart';
import 'book.dart';
import 'author.dart';
import 'publisher.dart';
import 'genre.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _isbnController = TextEditingController();
  final _numberOfPagesController = TextEditingController();

  Author? _selectedAuthor;
  Publisher? _selectedPublisher;
  Genre? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedAuthor = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthorsListPage(
                        refreshAuthorsList: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );

                  if (selectedAuthor!= null) {
                    setState(() {
                      _selectedAuthor = selectedAuthor;
                    });
                  }
                },
                child: Text('Select Author'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedPublisher = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PublishersListPage(
                        refreshPublishersList: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );

                  if (selectedPublisher!= null) {
                    setState(() {
                      _selectedPublisher = selectedPublisher;
                    });
                  }
                },
                child: Text('Select Publisher'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedGenre = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenreListPage(
                        refreshGenresList: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );

                  if (selectedGenre!= null) {
                    setState(() {
                      _selectedGenre = selectedGenre;
                    });
                  }
                },
                child: Text('Select Genre'),
              ),
              TextFormField(
                controller: _isbnController,
                decoration: InputDecoration(labelText: 'ISBN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ISBN';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numberOfPagesController,
                decoration: InputDecoration(labelText: 'Number of Pages'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of pages';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await http.put(
                      Uri.parse('http://localhost:8080/addBook'),
                      headers: {
                        'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
                        "Content-Type": "application/json",
                      },
                      body: jsonEncode(Book(
                        id: 0, // Assuming the server will generate the ID
                        title: _titleController.text,
                        author: _selectedAuthor!,
                        publisher: _selectedPublisher!,
                        genre: _selectedGenre!,
                        isbn: int.parse(_isbnController.text),
                        numberOfPages: int.parse(_numberOfPagesController.text),
                      ).toJson()),
                    );

                    if (response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book added successfully')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add book')),
                      );
                    }
                  }
                },
                child: Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
