import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'genre.dart';
import 'add_genre_page.dart';
import 'update_genre_page.dart';
import 'delete_genre_page.dart';

class GenreListPage extends StatefulWidget {
  final Function refreshGenresList;
  final Function(Genre) onGenreSelected;
  

  GenreListPage({
    required this.refreshGenresList,
    required this.onGenreSelected,
  });

  @override
  _GenreListPageState createState() => _GenreListPageState();
}

class _GenreListPageState extends State<GenreListPage> {
  late Future<List<Genre>> _genresFuture;
  List<Genre> _genres = [];
  bool _isGenresListEmpty = true;
  Genre? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _isGenresListEmpty = _genres.isEmpty;
    _genresFuture = _fetchGenres();
  }

  Future<List<Genre>> _fetchGenres() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/getGenres'),
        headers: {
          'Authorization': 'Basic ' + base64Encode(utf8.encode('test:123456')),
        },
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
         .map((data) => Genre.fromJson(data))
         .toList();
      } else {
        throw Exception('Failed to load genres, ${response.statusCode}');
      }
    } catch (error) {
      print('Fetch failed: $error');
      rethrow;
    }
  }

  void refreshGenresList() {
    setState(() {
      _genresFuture = _fetchGenres();
    });
  }

  List<Widget> _buildGenreList(List<Genre> genres) {
    if (genres.isEmpty) {
      return [Text('No genres added yet.')];
    } else {
      return genres.map((genre) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedGenre = genre;
              });
              widget.onGenreSelected(genre);
            },
            child: ListTile(
              title: Text('${genre.name}'),
              subtitle: Text('Genre'),
            ),
          )).toList();
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
          title: Center(child: Text('Genre List')),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<Genre>>(
                    future: _genresFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.hasData) {
                          _genres = snapshot.data!;
                          _isGenresListEmpty = _genres.isEmpty;
                        }
                        return _isGenresListEmpty
                         ? Center(child: Text('No genres added yet.'))
                          : ListView(children: _buildGenreList(_genres));
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
                            builder: (context) => AddGenrePage(
                              refreshGenresList: refreshGenresList,
                            ),
                          ),
                        );
                      },
                      child: Text('Add a new genre'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_selectedGenre!= null)...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateGenrePage(
                                genre: _selectedGenre!,
                                refreshGenresList: refreshGenresList,
                              ),
                            ),
                          );
                        },
                        child: Text('Edit Genre'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteGenrePage(
                                genre: _selectedGenre!,
                                refreshGenresList: refreshGenresList,
                              ),
                            ),
                          ).then((_) {
                            refreshGenresList();
                          });
                        },
                        child: Text('Delete Genre'),
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
