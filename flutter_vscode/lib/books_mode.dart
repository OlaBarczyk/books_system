import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book.dart'; // Assuming you have a Book model similar to Author
import 'books_list_page.dart';

class BooksMode extends StatefulWidget {
  final VoidCallback refreshBooksList;
  final Function(Book) onBookSelected;

  BooksMode({
    required this.refreshBooksList,
    required this.onBookSelected,
  });
  
  @override
  _BooksModeState createState() => _BooksModeState();
}

class _BooksModeState extends State<BooksMode> {

  Future<void> refreshBooksList() async {
    final String url = 'http://localhost:8080/getBooks'; // Update URL as per your API
    final String basicAuth = 'test:123456'; // Basic Auth credentials
    final String token = "Basic dGVzdDoxMjM0NTY=";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': token,
      });

      if (response.statusCode == 200) {
        List<dynamic> booksJson = json.decode(response.body);
        List<Book> books = booksJson.map((json) => Book.fromJson(json)).toList(); // Assuming Book has a fromJson method

        // Navigate to BooksListPage with the required parameters
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BooksListPage(
            refreshBooksList: refreshBooksList,
            onBookSelected: (Book book) {}, // Provide a function if needed
          )),
        );
      } else {
        throw Exception('Failed to load books, ${response.statusCode}');
      }
    } catch (e) {
      print(e);
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
          title: Text('Books Mode'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          // Removed the button here
        ),
      ),
    );
  }
}
