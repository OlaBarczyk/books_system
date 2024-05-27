import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book.dart'; 
import 'author.dart';
import 'publisher.dart';
import 'genre.dart';
import 'authors_list_page.dart';
import 'publishers_list_page.dart';
import 'genre_list_page.dart';

class UpdateBookPage extends StatefulWidget {
  final Book book;

  UpdateBookPage({required this.book});

  @override
  _UpdateBookPageState createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _isbnController;
  late TextEditingController _numberOfPagesController;


  Author? _selectedAuthor;
  Publisher? _selectedPublisher;
  Genre? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _isbnController = TextEditingController(text: widget.book.isbn.toString());
    _numberOfPagesController = TextEditingController(text: widget.book.numberOfPages.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _isbnController.dispose();
    _numberOfPagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Book'),
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
                    final response = await http.post(
                      Uri.parse('http://localhost:8080/updateBook'),
                      headers: {
                        'Authorization': 'Basic '+ base64Encode(utf8.encode('test:123456')),
                        "Content-Type": "application/json",
                      },
                      body: jsonEncode({
                        "id": widget.book.id,
                        "title": _titleController.text,
                        "isbn": int.parse(_isbnController.text),
                        "number_of_pages": int.parse(_numberOfPagesController.text),
                        "author": _selectedAuthor?.toJson(),
                        "publisher": _selectedPublisher?.toJson(),
                        "genre": _selectedGenre?.toJson(),
                      }),
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book updated successfully')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update book')),
                      );
                    }
                  }
                },
                child: Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
