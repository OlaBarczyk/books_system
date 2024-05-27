import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book.dart';

class BooksListPage extends StatefulWidget {
  final VoidCallback refreshBooksList;

  BooksListPage({Key? key, required this.refreshBooksList}) : super(key: key);

  @override
  _BooksListPageState createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage> {
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = _fetchBooks();
  }

  Future<List<Book>> _fetchBooks() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/getBooks'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
       .map((data) => Book.fromJson(data))
       .toList();
    } else {
      throw Exception('Failed to load books');
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
        child: FutureBuilder<List<Book>>(
          future: _books,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text("There are no books yet."),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text('Author: ${snapshot.data![index].author.firstName} ${snapshot.data![index].author.lastName}, Publisher: ${snapshot.data![index].publisher.name}, Genre: ${snapshot.data![index].genre.name}'),
                      trailing: Text('ISBN: ${snapshot.data![index].isbn}'),
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
