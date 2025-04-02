import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'genre.dart';
import 'genre_list_page.dart';

class GenresMode extends StatefulWidget {
  @override
  _GenresModeState createState() => _GenresModeState();
}

class _GenresModeState extends State<GenresMode> {
  
  Future<void> refreshGenresList() async {
    final String url = 'http://localhost:8080/getGenres';
    final String basicAuth = 'test:123456'; // Basic Auth credentials
    final String token = "Basic dGVzdDoxMjM0NTY=";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': token,
      });

      if (response.statusCode == 200) {
        List<dynamic> genresJson = json.decode(response.body);
        List<Genre> genres = genresJson.map((json) => Genre.fromJson(json)).toList();

        // Navigate to GenreListPage with the required parameters
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GenreListPage(
            refreshGenresList: refreshGenresList,
            onGenreSelected: (Genre genre) {}, // Provide a function if needed
            //genres: genres, // Pass the list of genres
          )),
        );
      } else {
        throw Exception('Failed to load genres, ${response.statusCode}');
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
          title: Text('Genres Mode'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              refreshGenresList(); // Call the refreshGenresList method here
            },
            child: Text('Download a list of existing genres'),
          ),
        ),
      ),
    );
  }
}
