import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'genre.dart';

class SelectGenreListPage extends StatefulWidget {
  final Function(Genre?) onGenreSelected;
  final List<Genre> genres;

  SelectGenreListPage({
    required this.onGenreSelected,
    required this.genres,
  });

  @override
  _SelectGenreListPageState createState() => _SelectGenreListPageState();
}

class _SelectGenreListPageState extends State<SelectGenreListPage> {
  List<Genre> _genres = [];
  Genre? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _genres = widget.genres;
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/getGenres'),
        headers: {
          'Authorization': 'Basic dGVzdDoxMjM0NTY=',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        _genres = jsonResponse.map((item) => Genre.fromJson(item)).toList();
        setState(() {});
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Genre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Genre>(
              hint: Text("Select a genre"),
              value: _selectedGenre,
              items: _genres.map((Genre genre) {
                return DropdownMenuItem<Genre>(
                  value: genre,
                  child: Text("${genre.name}"),
                );
              }).toList(),
              onChanged: (Genre? selectedGenre) {
                setState(() {
                  _selectedGenre = selectedGenre;
                });
                widget.onGenreSelected(selectedGenre);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onGenreSelected(_selectedGenre);
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
