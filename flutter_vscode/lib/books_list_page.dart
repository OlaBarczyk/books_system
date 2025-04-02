import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book.dart';
import 'add_book_page.dart';
import 'update_book_page.dart';
import 'delete_book_page.dart';

class BooksListPage extends StatefulWidget {
  final VoidCallback refreshBooksList;
  final Function(Book) onBookSelected;

  BooksListPage({required this.refreshBooksList, required this.onBookSelected});

  @override
  _BooksListPageState createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage> {
  late Future<List<Book>> _booksFuture;
  List<Book> _books = [];
  bool _isBooksListEmpty = true;
  Book? _selectedBook;

  @override
  void initState() {
    super.initState();
    widget.refreshBooksList();
    _booksFuture = _fetchBooks();
  }

  Future<List<Book>> _fetchBooks() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8080/getBooks'),
      headers: {
         'Authorization': "Basic dGVzdDoxMjM0NTY=",
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
   .map((data) => Book.fromJson(data))
   .toList();
    } else if (response.statusCode == 401) {
      print('Failed to load books due to unauthorized access.');
      return []; 
    } else {
      throw Exception('Failed to load books, ${response.statusCode}');
    }
  } catch (error) {
    print('Fetch failed: $error');
    rethrow;
  }
}


  void refreshBooks() async {
    Future <List<Book>> booksFuture = _fetchBooks();
   List<Book> books = await booksFuture;
    setState(() {
      _isBooksListEmpty = _books.isEmpty;
      _booksFuture = booksFuture;
      _books = books;
    });
  }

  List<Widget> _buildBookList(List<Book> books) {
  if (books.isEmpty) {
    return [Text('No books added yet.')];
  } else {
    return books.map((book) => ListTile(
          title: Text('${book.title}'),
          subtitle: Text('Author: ${book.author}, Publisher: ${book.publisher}, Genre: ${book.genre}'), // Adjusted to handle strings
          trailing: Text('ISBN: ${book.isbn}'),
          onTap: () {
            setState(() {
              _selectedBook = book;
            });
            widget.onBookSelected(book); // Call the passed callback with the selected book
          },
        )).toList();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books List'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple, Colors.green],
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<Book>>(
                    future: _booksFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.hasData) {
                          _books = snapshot.data!;
                          _isBooksListEmpty = _books.isEmpty;
                        }
                        return _isBooksListEmpty
                         ? Center(child: Text('No books added yet.'))
                          : ListView(children: _buildBookList(_books));
                      }
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 150),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBookPage(
                              refreshBooksList: refreshBooks,
                            ),
                          ),
                        );
                      },
                      child: Text('Add a new book'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_selectedBook!= null)
                   ...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateBookPage(
                                book: _selectedBook!,
                                refreshBooksList: refreshBooks,
                              ),
                            ),
                          );
                        },
                        child: Text('Edit Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedBook!= null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeleteBookPage(
                                  bookId: _selectedBook!.id,
                                  refreshBooksList: refreshBooks,
                                ),
                              ),
                            ).then((_) {
                              refreshBooks();
                            });
                          }
                        },
                        child: Text('Delete Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
