import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'author.dart'; 
import 'authors_list_page.dart';

class AuthorsMode extends StatefulWidget {
  @override
  _AuthorsModeState createState() => _AuthorsModeState();
}

class _AuthorsModeState extends State<AuthorsMode> {

  Future<void> refreshAuthorsList() async {
    final String url = 'http://localhost:8080/getAuthors';
    final String basicAuth = 'test:123456'; // Basic Auth credentials
    final String token = "Basic dGVzdDoxMjM0NTY=";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': token,
      });

      if (response.statusCode == 200) {
        List<dynamic> authorsJson = json.decode(response.body);
        List<Author> authors = authorsJson.map((json) => Author.fromJson(json)).toList();

        // Navigate to AuthorsListPage with the required parameters
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthorsListPage(
            refreshAuthorsList: refreshAuthorsList,
            onAuthorSelected: (Author author) {}, // Provide a function if needed
            //authors: authors, // Pass the list of authors
          )),
        );
      } else {
        throw Exception('Failed to load authors, ${response.statusCode}');
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
        title: Text('Authors Mode'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthorsListPage(
          refreshAuthorsList: refreshAuthorsList,
          onAuthorSelected: (Author author) {},
          //authors: [], // Pass an empty list initially
        ),
      ),
    );
  },
  child: Text('Add a new author'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),
),

          ],
        ),
      ),
    ),
  );
}
}
