import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'author.dart';
import 'add_author_page.dart';
import 'update_author_page.dart';
import 'delete_author_page.dart';

class AuthorsListPage extends StatefulWidget {
  final Function refreshAuthorsList;
  final Function(Author) onAuthorSelected;
 

  AuthorsListPage({
    required this.refreshAuthorsList,
    required this.onAuthorSelected,
    });

  @override
  _AuthorsListPageState createState() => _AuthorsListPageState();
}

class _AuthorsListPageState extends State<AuthorsListPage> {
  late Future<List<Author>> _authorsFuture;
  List<Author> _authors = [];
  bool _isAuthorsListEmpty = true;
  Author? _selectedAuthor;

@override
void initState() {
  super.initState();
  _isAuthorsListEmpty = _authors?.isEmpty?? true; 
  _authorsFuture = _fetchAuthors();
  
}


  Future<List<Author>> _fetchAuthors() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/getAuthors'),
        headers: {
          'Authorization': "Basic dGVzdDoxMjM0NTY=",
        },
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
        .map((data) => Author.fromJson(data))
        .toList();
      } else {
        throw Exception('Failed to load authors, ${response.statusCode}');
      }
    } catch (error) {
      print('Fetch failed: $error');
      rethrow;
    }
  }

  void refreshAuthorsList() {
    setState(() {
      _authorsFuture = _fetchAuthors();
    });
  }

  List<Widget> _buildAuthorList(List<Author> authors) {
    if (authors.isEmpty) {
      return [Text('No authors added yet.')];
    } else {
      return authors.map((author) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedAuthor = author;
              });
              widget.onAuthorSelected(author);
            },
            child: ListTile(
              title: Text('${author.firstName} ${author.lastName}'),
              subtitle: Text('Author'),
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
          title: Center(child: Text('Authors List')),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<Author>>(
                    future: _authorsFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Author>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.hasData) {
                          _authors = snapshot.data!;
                          _isAuthorsListEmpty = _authors.isEmpty;
                        }
                        return _isAuthorsListEmpty
                       ? Center(child: Text('No authors added yet.'))
                        : ListView(children: _buildAuthorList(_authors));
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
                            builder: (context) => AddAuthorPage(
                              refreshAuthorsList: refreshAuthorsList,
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
                    SizedBox(height: 10),
                    if (_selectedAuthor!= null)
                   ...[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAuthorPage(
                                  author: _selectedAuthor!,
                                  refreshAuthorsList: refreshAuthorsList,
                                ),
                              ),
                            );
                          },
                          child: Text('Edit Author'),
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
                                builder: (context) => DeleteAuthorPage(
                                  author: _selectedAuthor!,
                                  refreshAuthorsList: refreshAuthorsList,
                                ),
                              ),
                            ).then((_) {
                              refreshAuthorsList();
                            });
                          },
                          child: Text('Delete Author'),
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
