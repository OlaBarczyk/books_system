import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authors_list_page.dart';
import 'author.dart';
import 'publisher.dart';
import 'genre.dart';
import 'select_author_list_page.dart';
import 'select_publisher_list_page.dart';
import 'select_genre_list_page.dart';

class AddBookPage extends StatefulWidget {
  final VoidCallback refreshBooksList;

  AddBookPage({Key? key, required this.refreshBooksList}) : super(key: key);

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

  List<Author> _authors = [];
  List<Publisher> _publishers = [];
  List<Genre> _genres = [];

  Future<void> _addBook() async {
    final String title = _titleController.text.trim();
    final String ISBN = _isbnController.text.trim();
    final String numberOfPages = _numberOfPagesController.text.trim();



    final response = await http.put(
       Uri.parse('http://localhost:8080/addBook'),
    headers: {
      'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "title": title,
      "isbn": ISBN,
      "number_of_pages": numberOfPages,
      "author": _selectedAuthor!.toJson(),
      "publisher": _selectedPublisher!.toJson(),
      "genre": _selectedGenre!.toJson()
    }),
    );

    if (response.statusCode == 201) {
      _titleController.clear();
      _isbnController.clear();
      _numberOfPagesController.clear();
      _selectedAuthor = null;
      _selectedPublisher = null;
      _selectedGenre = null;
      widget.refreshBooksList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book successfully added'),
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
          content: Text('Forbidden: You do not have permission to add books'),
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

  void _onAuthorSelected(Author author) {
    setState(() {
      _selectedAuthor = author;
    });
  }

  void _onPublisherSelected(Publisher publisher) {
    setState(() {
      _selectedPublisher = publisher;
    });
  }

  void _onGenreSelected(Genre genre) {
    setState(() {
      _selectedGenre = genre;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Add Book'),
    ),
    body: SingleChildScrollView(
      child: Form(
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
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _isbnController,
              decoration: InputDecoration(labelText: 'ISBN'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
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
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectAuthorListPage(
                      onAuthorSelected: (author) {
                        setState(() {
                          _selectedAuthor = author;
                        });
                      },
                      authors: _authors,
                    ),
                  ),
                );
              },
              child: Text('Select Author'),
            ),
            Padding(padding: EdgeInsets.only(top: 25)),
            Text('${_selectedAuthor?.firstName} ${_selectedAuthor?.lastName}'),
            Padding(padding: EdgeInsets.only(top: 35)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectPublisherListPage(
                      onPublisherSelected: (publisher) {
                        setState(() {
                          _selectedPublisher = publisher;
                        });
                      },
                      publishers: _publishers,
                    ),
                  ),
                );
              },
              child: Text('Select Publisher'),
            ),
            Padding(padding: EdgeInsets.only(top: 25)),
            Text('${_selectedPublisher?.name}'),
            Padding(padding: EdgeInsets.only(top: 25)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectGenreListPage(
                      onGenreSelected: (genre) {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                      genres: _genres,
                    ),
                  ),
                );
              },
              child: Text('Select Genre'),
            ),
            Padding(padding: EdgeInsets.only(top: 25)),
            Text('${_selectedGenre?.name}'),
            Padding(padding: EdgeInsets.only(top: 25)),
             ElevatedButton(
                onPressed: _addBook,
                child: Text('Add book'),
              ),
          ],
        ),
      ),
     
    ),
    ),
  );
  
}
}
