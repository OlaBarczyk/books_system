import 'package:flutter/material.dart';
import 'add_book_page.dart';
import 'books_list_page.dart';

class BooksMode extends StatefulWidget {
  @override
  _BooksModeState createState() => _BooksModeState();
}

class _BooksModeState extends State<BooksMode> {
  void refreshBooksList() {
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
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BooksListPage(refreshBooksList: refreshBooksList)),
              );
            },
            child: Text('Download a list of existing books'),
          ),
        ),
      ),
    );
  }
}
